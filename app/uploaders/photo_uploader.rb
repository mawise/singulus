# frozen_string_literal: true

require 'image_processing/mini_magick'

# Uploader for photo assets.
class PhotoUploader < Shrine
  plugin :add_metadata
  plugin :determine_mime_type
  plugin :signature
  plugin :remote_url, max_size: 20 * 1024 * 1024
  plugin :store_dimensions
  plugin :derivatives

  add_metadata :sha256 do |io|
    calculate_signature(io, :sha256)
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      jpeg_post: magick.quality(85).resize_to_limit(660, nil).convert('jpeg').call,
      webp_post: magick.quality(85).define(webp: { lossless: true }).resize_to_limit(660, nil).convert('webp').call
    }
  end
end
