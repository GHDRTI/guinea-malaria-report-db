module HasSpreadsheet extend ActiveSupport::Concern

  def presigned_post
    S3_BUCKET.presigned_post key: workbook_file_bucket_path(true),
      success_action_status: '201',
      acl: 'private'
  end

  def direct_workbook_upload path
    update_attribute 'filename', Pathname.new(path).basename
    object = S3_BUCKET.object workbook_file_bucket_path
    object.upload_file path
  end

  def workbook_file_url expires=3600
    S3_PRESIGNER.presigned_url :get_object, bucket: S3_BUCKET_NAME,
      key: workbook_file_bucket_path,
      expires_in: expires
  end

  def load_spreadsheet!
    begin
      Roo::Spreadsheet.open(workbook_file_url, extension: :xlsx)
    rescue Zip::Error
      Roo::Spreadsheet.open(workbook_file_url)
    end
  end

  def workbook_file_bucket_path post=false
    "#{S3_WORKBOOK_FILE_PATH}/#{id}/#{post ? '${filename}' : filename}"
  end

end