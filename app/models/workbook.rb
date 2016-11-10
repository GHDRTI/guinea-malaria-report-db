class Workbook < ActiveRecord::Base
  belongs_to :district

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

    end
    if !params[:start_date]

    end
    if !params[:end_date]

    end
    where(where_clauses.join(" AND "), where_params)
      .order('reporting_year desc, reporting_month desc')
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

end
