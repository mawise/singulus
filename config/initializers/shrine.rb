# frozen_string_literal: true

require 'shrine/storage/s3'

minio_options = {
  access_key_id: ENV.fetch('MINIO_ACCESS_KEY'),
  secret_access_key: ENV.fetch('MINIO_SECRET_KEY'),
  endpoint: 'http://localhost:9000',
  region: 'us-east-1',
  force_path_style: true,
  public: true
}

url_options = {
  store: {
    host: Rails.configuration.assets.url,
    public: true
  }
}

case Rails.env
when 'development'
  s3_options = minio_options.merge(bucket: 'singulus-development')
when 'test'
  s3_options = minio_options.merge(bucket: 'singulus-test')
when 'production'
  s3_options = { bucket: ENV.fetch('ASSETS_BUCKET') }
end

Shrine.logger = Rails.logger
Shrine.logger.level = Logger::WARN if Rails.env.test?

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
  store: Shrine::Storage::S3.new(**s3_options)
}

Shrine.plugin :instrumentation, notifications: ActiveSupport::Notifications
Shrine.plugin :activerecord
Shrine.plugin :url_options, url_options
