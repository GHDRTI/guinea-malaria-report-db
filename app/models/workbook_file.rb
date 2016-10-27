class WorkbookFile < ActiveRecord::Base
  
  belongs_to :workbook
  belongs_to :user

  STATUSES = %w(uploading verifying invalid verified importing error imported 
    archived).map(&:to_sym)

  IGNORE_SHEETS_NAMED = ['Rapport Mensuel Palu', 'TOTAL District']
  IGNORE_SHEETS_EMPTY_CELLS = [ ['D',3], ['D',4] ]

  def validate_file
    # ERRORS
    # Check month and district of sheets are same and are dates, with at least month & year
    # Facility name present on each workbook
    # Check that district for workbook is present in the DB (with alternative spellings)
    
    # WARNINGS
    # Check that facilities are known, UI should offer to create facility if doesn't exist

  end

  def validate_sheet
    
  end 

  def ignore_sheet? name, sheet
    return IGNORE_SHEETS_NAMED.include?(name) || 
      IGNORE_SHEETS_EMPTY_CELLS.all? {|cell| sheet.cell(*cell).blank? }
  end

  # Create or update derived report objects for this workbook file.  Wrapped in a 
  # single transaction, errors will be saved in import_errors
  def populate_reports!
    ActiveRecord::Base.transaction do
      spreadsheet = load_spreadsheet!
      spreadsheet.sheets.each do |sheet_name|
        sheet = spreadsheet.sheet(sheet_name)
        if ignore_sheet?(sheet_name, sheet)
          puts "WorkbookFile[#{id}]: Ignoring worksheet '#{sheet_name}'"
        else
          puts "WorkbookFile[#{id}]: Importing worksheet '#{sheet_name}'"
          WorkbookFacilityMonthlyReport.import_sheet! self, sheet
        end
      end
    end
  end

  def presigned_post
    S3_BUCKET.presigned_post key: workbook_file_bucket_path(true),
      success_action_status: '201',
      acl: 'private'
  end

  def workbook_file_url expires=3600
    S3_PRESIGNER.presigned_url :get_object, bucket: S3_BUCKET_NAME,
      key: workbook_file_bucket_path,
      expires_in: expires
  end


  private

    def load_spreadsheet!
      Roo::Spreadsheet.open(workbook_file_url, extension: :xls)
    end

    def workbook_file_bucket_path post=false
      "#{S3_WORKBOOK_FILE_PATH}/#{id}/#{post ? '${filename}' : filename}"
    end

end
