class WorkbookFile < ActiveRecord::Base
  include Validatable, HasSpreadsheet, DateHelper
  
  belongs_to :workbook
  belongs_to :user
  has_many :workbook_facility_monthly_reports

  STATUSES = %w(uploading verifying invalid verified importing error imported 
    active archived).map(&:to_sym)
  IMPORT_OVERRIDES = %w(reporting_year reporting_month district_id health_facilities)

  CELL_DISTRICT_NAME = ['N', 3]
  CELL_DATE          = ['D', 3]

  IGNORE_SHEETS_NAMED = [
    'Rapport Mensuel Palu', 
    'TOTAL District',
    'SS Armees',
    /Rapport Palu/,
    /Feuil/,
    /^CS /
  ]
  # make sure that there is a date, heath facility and cases tested for RDT
  IGNORE_SHEETS_EMPTY_CELLS = [ ['D',3], ['D',4], ['K',11] ]

  WARNINGS_CELL_DATES = [
    ['I',48],
    ['U',48]
  ]


  def import!
    begin
      do_import
      update_attribute :status, 'imported'
    rescue => e
      update_attribute :status, 'error'
      update_attribute :import_errors, {
        error: e.message,
        message: e.backtrace
      }
      raise
    end
  end
  
  def validate!
    begin
      validations = do_validations
      update_attribute(:validation_errors, validations)
      update_attribute(:status, validations[:errors].empty? ? 'verified' : 'invalid')
    rescue => e
      update_attribute :status, 'error'
      update_attribute :import_errors, {
        error: e.message,
        message: e.backtrace
      }
    end
  end

  def activate!
    WorkbookFile.transaction do
      WorkbookFile.where("id != :id and workbook_id = :workbook_id and status = 'active'", 
        id: id, workbook_id: workbook_id).update_all(status: 'archived')
      update_attribute(:status, 'active')
    end
  end

  def archive!
    WorkbookFile.transaction do
      update_attribute(:status, 'archived')
    end
  end

  def reimport!
    WorkbookFile.transaction do
      if workbook_facility_monthly_reports
        workbook_facility_monthly_reports.each do |workbook_facility_monthly_report|
          workbook_facility_monthly_report.workbook_facility_inventory_reports.each do |r|
            r.destroy
          end
          workbook_facility_monthly_report.workbook_facility_malaria_group_reports.each do |r|
            r.destroy
          end
          workbook_facility_monthly_report.destroy
        end
        do_import
      else
        "Workbook File [#{id}] does not have a workbook_facility_monthly_report for some reason"
      end
    end
  end

  def assign_workbook district_name, year, month
    district = District.named district_name
    if district
      Workbook.assign_workbook_file self, district, year, month
    else
      self.workbook = nil
    end
  end 

  def importable_sheet_names spreadsheet
    spreadsheet.sheets.select do |sheet_name|
      !ignore_sheet?(sheet_name, spreadsheet.sheet(sheet_name))
    end
  end

  def ignore_sheet? name, sheet
    IGNORE_SHEETS_NAMED.each do |ignore_name|
      if ignore_name.is_a? Regexp
        return true if ignore_name.match(name.strip)
      else
        return true if ignore_name.downcase == name.strip.downcase
      end
    end
    
    if !import_overrides.blank? && !import_overrides["health_facilities"].blank? &&
        import_overrides["health_facilities"][name] == 'ignore'
      return true
    end
    return false
  end

  def get_import_override type
    return nil if import_overrides.blank?
    if 'reporting_date' == type && import_overrides['reporting_month'] && 
      import_overrides['reporting_year']
      return Date.new import_overrides['reporting_year'].to_i, 
        import_overrides['reporting_month'].to_i
    elsif 'district' == type && import_overrides['district_id']
      return District.where("id = ?", import_overrides['district_id'].to_i).first
    end
  end

  def get_health_facility_override sheet_name
    if import_overrides.blank? || import_overrides["health_facilities"].blank? ||
        import_overrides["health_facilities"][sheet_name].blank?
      return nil
    else
      return HealthFacility.where(id: import_overrides["health_facilities"][sheet_name].to_i).first
    end
  end

  private

    # Create or update derived report objects for this workbook file.  Wrapped in a 
    # single transaction, errors will be saved in import_errors
    def do_import
      if %w(verifying invalid error).include?(self.status)
        raise "Workbook file must be valid to import reports"
      else
        WorkbookFile.transaction do
          spreadsheet = load_spreadsheet!
          spreadsheet.sheets.each do |sheet_name|
            sheet = spreadsheet.sheet(sheet_name)
            if ignore_sheet?(sheet_name, sheet)
              puts "WorkbookFile[#{id}]: Ignoring worksheet '#{sheet_name}'"
            else
              puts "WorkbookFile[#{id}]: Importing worksheet '#{sheet_name}'"
              WorkbookFacilityMonthlyReport.import_sheet! self, sheet, sheet_name
            end
          end
        end
      end
    end

    # Validate the file.  If valid, assign or create the workbook
    def do_validations
      

      validations = {
        errors: [],
        warnings: []
      }
      invariants = {
        district: nil,
        year: nil,
        month: nil
      }
      spreadsheet = load_spreadsheet!
      sheet_names_to_validate = importable_sheet_names spreadsheet

      # Find district, month, year and assign workbook
      first_sheet = spreadsheet.sheet(sheet_names_to_validate.first)
      district_name = first_sheet.cell(*CELL_DISTRICT_NAME)
      district = get_import_override("district") || District.named(district_name)
      if (district.nil?)
        validations[:errors] << t_err(:unknown_district, district_name: district_name)
      end
      date = get_import_override("reporting_date") || first_sheet.cell(*CELL_DATE)
      if date.is_a?(Date) && !date.blank?
        if district
          Workbook.assign_workbook_file self, district, date.year, date.month
        else
          self.workbook = nil
        end
      else
        validations[:errors] << t_err(:invalid_workbook_month, date: date)
      end

      # Make sure each sheet is for the same district unless district is overridden
      if district && !get_import_override("district")
        sheet_names_to_validate.each do |sheet_name|
          name = spreadsheet.sheet(sheet_name).cell *CELL_DISTRICT_NAME 
          unless district.is_also_named? (name || '').to_s
            validations[:errors] << t_err(:district_not_same, 
              workbook_district_name: district.name,
              sheet_name: sheet_name, 
              sheet_district_name: name)
          end
        end
      end

      sheet_names_to_validate.each do |sheet_name|
        sheet = spreadsheet.sheet(sheet_name)
        
        if workbook && workbook.district
          # Find facility in detected district
          facility_name = sheet.cell(*WorkbookFacilityMonthlyReport::CELL_FACILITY_NAME).to_s
          facility = get_health_facility_override(sheet_name) ||
            HealthFacility.district_named(workbook.district, facility_name)
          
          if IGNORE_SHEETS_EMPTY_CELLS.any? { |cell| sheet.cell(*cell).blank? }
            validations[:errors] << t_err(:empty_malaria_report, 
                    district_name: workbook.district.name, 
                    facility_name: facility_name,
                    sheet_name: sheet_name)
            next
          end

          unless facility
            validations[:errors] << t_err(:unknown_facility, 
              district_name: workbook.district.name, 
              facility_name: facility_name,
              sheet_name: sheet_name)
          end
  
         end
 
      end

      validations[:warnings] = get_warnings spreadsheet, sheet_names_to_validate

      return validations
    end

    def get_warnings spreadsheet, sheet_names_to_validate
      warnings = []
      sheet_names_to_validate.each do |sheet_name|
        sheet = spreadsheet.sheet(sheet_name)

        # Validate dates
        WARNINGS_CELL_DATES.each do |cell|
          val = sheet.cell(*cell)
          if !val.blank? && !is_a_date?(val)
            warnings << t_err(:invalid_date_sheet, date: val, sheet_name: sheet_name)
          end
        end
      end

      return warnings
    end

end
