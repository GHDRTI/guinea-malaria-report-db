class WorkbookFileValidationWorker
  include Sidekiq::Worker

  sidekiq_options retry: 2

  def perform workbook_file_id
    @workbook_file = WorkbookFile.find workbook_file_id
    @workbook_file.validate!
  end

end