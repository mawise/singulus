# frozen_string_literal: true

require 'shrine/storage/s3'

case Rails.env
when 'development', 'test'
  s3_options = {
    access_key_id: ENV['MINIO_ACCESS_KEY'],
    secret_access_key: ENV['MINIO_SECRET_KEY'],
    endpoint: 'http://localhost:9000',
    region: 'us-east-1',
    force_path_style: true,
    public: true,
    bucket: "singulus-#{Rails.env}"
  }
when 'production'
  s3_options = { bucket: ENV['ASSETS_BUCKET'] }
end

url_options = {
  store: {
    host: Rails.configuration.x.assets.url,
    public: true
  }
}

Shrine.logger = Rails.logger
Shrine.logger.level = Logger::WARN if Rails.env.test?

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
  store: Shrine::Storage::S3.new(**s3_options)
}

Shrine.plugin(:instrumentation, notifications: ActiveSupport::Notifications)
Shrine.plugin(:activerecord)
Shrine.plugin(:url_options, **url_options)
