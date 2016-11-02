class MonthlyMalariaController < ApplicationController

  def index

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

end