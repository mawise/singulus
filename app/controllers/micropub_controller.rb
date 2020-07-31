# frozen_string_literal: true

# [Micropub](https://micropub.spec.indieweb.org/) server implementation.
class MicropubController < ActionController::API
  include Doorkeeper::Helpers::Controller

  before_action :doorkeeper_authorize!

  def create
    case request.media_type
    when 'application/x-www-form-urlencoded'
      handle_form_encoded
    when 'application/json'
      handle_json
    end
  end

  def show
    case query_params[:q]
    when 'config'
      render json: {}.to_json
    end
  end

  private

  def handle_form_encoded
    attrs = post_params_form_encoded.merge(categories: post_params_form_encoded[:category])
    attrs.delete(:category)
    create_post(attrs)
  end

  def handle_json
    attrs = post_params_json[:properties].to_h.transform_values(&:first)
    create_post(attrs)
  end

  def create_post(attrs)
    @post = Post.new(attrs)
    @post.author_id = doorkeeper_token.resource_owner_id
    @post.published_at = Time.now.utc
    if save_post
      PublishWorker.perform_async('create', @post.id)
      head :accepted, location: @post.permalink_url
    else
      render json: { error: 'invalid_request', error_description: @post.errors.full_messages }.to_json
    end
  end

  def post_params_form_encoded
    params[:category] = Array(params[:category]) if params.key?(:category)
    params.permit(:content, category: [])
  end

  def post_params_json
    params.permit(type: [], properties: { content: [] })
  end

  def create_attributes_json
    post_params_json[:properties].map { |k, v| }
  end

  def save_post
    on_retry = proc do |_, _try, _, _|
      Rails.logger.info('Collison generating short_uid, trying again')
    end
    Retriable.retriable on: [ActiveRecord::RecordNotUnique], on_retry: on_retry do
      @post.save
    end
  end

  def query_params
    params.permit(:q)
  end

  def doorkeeper_unauthorized_render_options(*)
    { json: { error: 'unauthorized' } }
  end
end
