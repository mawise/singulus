# frozen_string_literal: true

require 'shrine/storage/s3'

s3_options = {
  bucket: ENV.fetch('ASSETS_BUCKET'),
  public: true
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
  store: Shrine::Storage::S3.new(**s3_options)
}

Shrine.plugin :activerecord
Shrine.plugin :url_options, store: { host: ENV.fetch('ASSETS_URL') }
