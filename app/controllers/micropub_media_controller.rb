# frozen_string_literal: true

# Provides a Micropub [media endpoint](https://micropub.spec.indieweb.org/#media-endpoint).
class MicropubMediaController < MicropubController
  def create
    if request.media_type == 'multipart/form-data'
      handle_media_upload
    else
      handle_unsupported_media_type
    end
  end

  private

  def handle_media_upload
    @asset = Asset.new(media_params)
    if @asset.save
      head :created, location: @asset.file_url
    else
      render json: { error: 'invalid_request', error_description: @asset.errors.full_messages }.to_json
    end
  end

  def media_params
    params.permit(:file)
  end
end
