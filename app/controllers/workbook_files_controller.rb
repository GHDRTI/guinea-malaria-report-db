class WorkbookFilesController < ApplicationController

  before_filter :load_workbook_file, except: [:new]

  def new
    @workbook_file = WorkbookFile.create user: current_user, status: 'uploading'
    return redirect_to @workbook_file
  end

  def show 
  end

  def status
    return render text: @workbook_file.status
  end

  def uploaded
    @workbook_file.status = 'verifying'
    @workbook_file.filename = params[:workbook_file][:filename]
    @workbook_file.storage_url = params[:workbook_file][:storage_url]
    @workbook_file.save!

    WorkbookFileValidationWorker.perform_async @workbook_file.id

    redirect_to action: 'show'
  end

  private

    def load_workbook_file
      @workbook_file = WorkbookFile.find params[:id]   
    end

end
