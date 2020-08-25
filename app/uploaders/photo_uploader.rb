# frozen_string_literal: true

require 'image_processing/mini_magick'

# Uploader for photo assets.
class PhotoUploader < Shrine
  plugin :instrumentation
  plugin :refresh_metadata
  plugin :add_metadata
  plugin :determine_mime_type
  plugin :signature
  plugin :remote_url, max_size: 20 * 1024 * 1024
  plugin :store_dimensions, analyzer: :mini_magick
  plugin :derivatives

  add_metadata :sha256 do |io|
    calculate_signature(io, :sha256)
  end

  Attacher.derivatives(:downloads) do |original|
    magick = ImageProcessing::MiniMagick.source(original).loader(page: 0)
    {
      download_small: magick.quality(85).resize_to_limit(640, nil).convert('jpeg').call,
      download_medium: magick.quality(85).resize_to_limit(1024, nil).convert('jpeg').call,
      download_large: magick.quality(85).resize_to_limit(2048, nil).convert('jpeg').call,
      download_high: magick.quality(100).resize_to_limit(3600, nil).convert('jpeg').call
    }
  end

  Attacher.derivatives(:meta) do |original|
    magick = ImageProcessing::MiniMagick.source(original).loader(page: 0)
    aspect_ratio = file.metadata['width'].to_f / file.metadata['height']

    twitter_card_dimensions = aspect_ratio.to_d == 1.0.to_d ? [400, 400] : [400, nil]

    {
      opengraph: magick.quality(85).resize_to_limit(1200, 630).convert('jpeg').call,
      twitter_card: magick.quality(85).resize_to_limit(*twitter_card_dimensions).convert('jpeg').call
    }
  end

  Attacher.derivatives(:wilson) do |original|
    magick = ImageProcessing::MiniMagick.source(original).loader(page: 0)
    {
      wilson_list: magick.quality(85).resize_to_limit(660, nil).convert('jpeg').call,
      wilson_post: magick.quality(85).resize_to_limit(2400, nil).convert('jpeg').call
    }
  end
end
