# frozen_string_literal: true

# Uploader for photo assets.
class PhotoUploader < Shrine
  plugin :add_metadata
  plugin :determine_mime_type
  plugin :signature
  plugin :remote_url, max_size: 20 * 1024 * 1024
  plugin :store_dimensions

  add_metadata :sha256 do |io|
    calculate_signature(io, :sha256)
  end
end
