class Workbook < ActiveRecord::Base
  belongs_to :district
  has_many :workbook_files

  has_one :active_workbook_file, -> { 
    where("status = 'active'").order('uploaded_at desc').limit(1) 
  }, class_name: 'WorkbookFile'

  has_one :recent_workbook_file, -> { 
    order('uploaded_at desc').limit(1) 
  }, class_name: 'WorkbookFile'


  def self.search params
    where_clauses = []
    where_params = {}
    if !params[:q].blank?
      where_clauses << "(workbook_files.filename ilike :q OR districts.name ilike :q OR users.name ilike :q)"
      where_params[:q] = "%#{params[:q]}%"
    end
    if !params[:reporting_year].blank?
      where_clauses << 'reporting_year = :reporting_year'
      where_params[:reporting_year] = params[:reporting_year]
    end
    if !params[:reporting_month].blank? && params[:reporting_month].to_i > 0
      where_clauses << 'reporting_month = :reporting_month'
      where_params[:reporting_month] = params[:reporting_month]
    end
    where(where_clauses.join(" AND "), where_params)
      .joins(:district, {:workbook_files => :user})
      .order('reporting_year desc, reporting_month desc').distinct
  end

  def self.assign_workbook_file workbook_file, district, year, month
    workbook = where(district: district, reporting_year: year, 
      reporting_month: month).first
    if workbook.nil?
      workbook = Workbook.create district: district, reporting_year: year, 
        reporting_month: month
    end
    workbook_file.workbook = workbook
  end

  def current_status
    if active_workbook_file
      active_workbook_file.status
    elsif recent_workbook_file
      recent_workbook_file.status
    else
      'missing'
    end
  end

  def dhis2_period
    "#{reporting_year.to_s}#{reporting_month.to_s.rjust(2, '0')}"
  end

  def dhis2_period_date
    # creates a date that can be used for an approimate complete data (and other things)
    "#{reporting_year.to_s}-#{reporting_month.to_s.rjust(2, '0')}-15"
  end

end
