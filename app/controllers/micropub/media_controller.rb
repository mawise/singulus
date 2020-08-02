# frozen_string_literal: true

module Micropub
  # Provides a Micropub [media endpoint](https://micropub.spec.indieweb.org/#media-endpoint).
  class MediaController < MicropubController
    def create
      if request.media_type == 'multipart/form-data'
        handle_media_upload
      else
        handle_unsupported_media_type
      end
    end

    private

    def handle_media_upload
      @photo = Photo.new(asset_params)
      if @photo.save
        head :created, location: @photo.file_url
      else
        render json: { error: 'invalid_request', error_description: @asset.errors.full_messages }.to_json
      end
    end

    def asset_params
      params.permit(:file)
    end
  end
end
