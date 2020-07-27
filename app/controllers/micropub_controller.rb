# frozen_string_literal: true

# [Micropub](https://micropub.spec.indieweb.org/) server implementation.
class MicropubController < ActionController::API
  before_action :doorkeeper_authorize!
  #-> { doorkeeper_authorize!(*ALL_SCOPES) }

  def create
    head :accepted, location: root_url
  end

  def show
    case query_params[:q]
    when 'config'
      render json: {}.to_json
    end
  end

  private

  def query_params
    params.permit(:q)
  end

  def doorkeeper_unauthorized_render_options(*)
    { json: { error: 'unauthorized' } }
  end
end
