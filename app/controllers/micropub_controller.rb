# frozen_string_literal: true

# [Micropub](https://micropub.spec.indieweb.org/) server implementation.
class MicropubController < ActionController::API
  include Doorkeeper::Helpers::Controller

  before_action :doorkeeper_authorize!

  def create
    case request.media_type
    when 'application/x-www-form-urlencoded', 'multipart/form-data'
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

  FIRST_VALUE_ONLY = %i[content].freeze

  def handle_form_encoded
    attrs = post_params_form_encoded
    attrs[:categories] = attrs.delete(:category)
    attrs[:assets_attributes] = (attrs.delete(:photo) || []).each_with_object([]) { |upload, a| a.append({ file: upload }) }
    attrs.delete(:category)
    create_post(attrs)
  end

  def handle_file_uploads
    post_params_files[:photo].each do |file|
    end
  end

  def handle_json
    attrs = post_params_json[:properties].to_h.deep_symbolize_keys.each_with_object({}) do |(k, v), h|
      h[k] = if FIRST_VALUE_ONLY.include?(k)
               v.first
             else
               v
             end
    end
    attrs[:categories] = attrs.delete(:category)
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
    params[:photo] = Array(params[:photo]) if params.key?(:photo)
    params.permit(:content, category: [], photo: [])
  end

  def post_params_json
    params.permit(type: [], properties: { content: [], category: [] })
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
