# frozen_string_literal: true

module Micropub
  # Provides a Micropub [querying endpoint](https://micropub.spec.indieweb.org/#querying)
  class QueriesController < MicropubController
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
end
