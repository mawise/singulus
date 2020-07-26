# frozen_string_literal: true

class MicropubController < ActionController::API
  before_action -> { doorkeeper_authorize!(*ALL_SCOPES) }

  def create
    head :created, location: 'https://tonyburns.net', content_type: 'application/json'
  end

  def show
    permitted = params.permit(:q)
    query = permitted[:q]
    if query && query == 'config'
      render json: config_body.to_json
    else
      render json: {}.to_json
    end
  end

  private

  def config_body
    {
      'media-endpoint' => micropub_url,
      'syndicate-to': []
    }
  end
end
