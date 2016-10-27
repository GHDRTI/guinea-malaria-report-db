Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], 
    ENV['AWS_SECRET_ACCESS_KEY'])
})

S3_WORKBOOK_FILE_PATH = ENV['S3_WORKBOOK_FILE_PATH']

S3_BUCKET_NAME = ENV['S3_BUCKET']
S3_BUCKET = Aws::S3::Resource.new.bucket S3_BUCKET_NAME
S3_PRESIGNER = Aws::S3::Presigner.new