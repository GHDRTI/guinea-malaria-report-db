class MonthlyMalariaController < ApplicationController

  before_filter :populate_districts, only: ['index', 'report']

  def index
    populate_default_params
    query_case_report
  end

  def report
    query_case_report
    return render action: 'index'
  end

  def workbook
    @workbook = Workbook.find params[:id]
  end

  def workbooks
    @workbooks = Workbook.all.order('reporting_year desc, reporting_month desc')
  end

  def search
    @workbooks = Workbook.all
    return render action: 'workbooks'
  end

  private

    def query_case_report
      query_params = {
        grouping: params[:grouping].split(',')
      }
      if params[:grouping] == 'district,health_facility'
        query_params[:district_id] = params[:district_id] 
      end
      if params[:aggregate] == 'year'
        query_params[:reporting_year] = params[:reporting_year]
      end
      if params[:aggregate] == 'month'
        query_params[:reporting_year] = params[:reporting_year]
        query_params[:reporting_month] = params[:reporting_month]
      end
      puts "querying:"
      puts query_params
      @reports = FacilityMonthlyReport.case_report query_params
    end

    def populate_default_params
      params[:grouping] = 'district'
      params[:aggregate] = 'all'
    end

    def populate_districts
      @districts = District.all.order("name asc")
    end

end