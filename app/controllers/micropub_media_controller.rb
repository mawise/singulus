# frozen_string_literal: true

# Provides a Micropub [media endpoint](https://micropub.spec.indieweb.org/#media-endpoint).
class MicropubMediaController < ActionController::API
  include Doorkeeper::Helpers::Controller

  before_action :doorkeeper_authorize!

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

  def handle_unsupported_media_type
    error = { error: 'invalid_request', error_description: 'Unsupported media type' }
    render json: error.to_json, status: :unsupported_media_type
  end

  def media_params
    params.permit(:file)
  end

  def doorkeeper_unauthorized_render_options(*)
    { json: { error: 'unauthorized' } }
  end
end
