# frozen_string_literal: true

# Provides a Micropub [querying endpoint](https://micropub.spec.indieweb.org/#querying)
class MicropubQueriesController < MicropubController
  def show
    case query_params[:q]
    when 'config'
      render json: { 'media-endpoint': micropub_media_url }.to_json
    end
  end

  private

  def query_params
    params.permit(:q)
  end
end
