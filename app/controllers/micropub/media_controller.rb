# frozen_string_literal: true

module Micropub
  # Provides a Micropub [media endpoint](https://micropub.spec.indieweb.org/#media-endpoint).
  class MediaController < MicropubController
    before_action :handle_unsupported_media_type!

    before_action -> { doorkeeper_authorize!(:media) }

    def create
      @photo = Photo.new(asset_params)
      if @photo.save
        head :created, location: @photo.file_url
      else
        render json: { error: 'invalid_request', error_description: @asset.errors.full_messages }.to_json
      end
    end

    private

    def supported_media_types
      %w[multipart/form-data]
    end

    def asset_params
      params.permit(:file)
    end
  end
end
