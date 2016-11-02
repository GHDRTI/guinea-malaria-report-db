class WorkbookFilesController < ApplicationController

  before_filter :load_workbook_file, except: [:new]

  def new
    @workbook_file = WorkbookFile.create! user: current_user
    return redirect_to @workbook_file
  end

  def show 
  end

  def uploaded
    @workbook_file.filename = params[:workbook_file][:filename]
    @workbook_file.storage_url = params[:workbook_file][:storage_url]
    @workbook_file.save!
    render action: 'show'
  end

  private

    def load_workbook_file
      @workbook_file = WorkbookFile.find params[:id]   
    end

end
