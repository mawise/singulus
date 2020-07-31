# frozen_string_literal: true

# [Micropub](https://micropub.spec.indieweb.org/) server implementation.
class MicropubController < ActionController::API # rubocop:disable Metrics/ClassLength
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
      render json: { 'media-endpoint': micropub_url }.to_json
    end
  end

  private

  FIRST_VALUE_ONLY = %i[content].freeze

  def handle_form_encoded
    if media_params[:file].present?
      create_asset(media_params[:file])
    else
      attrs = post_params_form_encoded
      attrs[:categories] = attrs.delete(:category)

      photos = attrs.delete(:photo) || []
      transform_photos_form_encoded(photos, attrs)

      attrs.delete(:category)
      create_post(attrs)
    end
  end

  def transform_photos_form_encoded(photos, attrs)
    attrs[:assets_attributes] = photos.each_with_object([]) do |upload, a|
      if upload.is_a?(String) && upload.start_with?(ENV['ASSETS_URL'])
        associate_existing_asset(upload, nil, attrs)
      elsif upload.is_a?(String)
        a.append({ file_remote_url: upload })
      else
        a.append({ file: upload })
      end
    end
  end

  def handle_json
    attrs = transform_json_properties(post_params_json[:properties].to_h)
    attrs[:categories] = attrs.delete(:category)
    attrs[:assets_attributes] = transform_json_assets(attrs)
    create_post(attrs)
  end

  def transform_json_properties(props)
    props.deep_symbolize_keys.each_with_object({}) do |(k, v), h|
      h[k] = if FIRST_VALUE_ONLY.include?(k)
               v.first
             else
               v
             end
    end
  end

  def transform_json_assets(attrs) # rubocop:disable Metrics/MethodLength
    (attrs.delete(:photo) || []).each_with_object([]) do |item, a|
      if item.respond_to?(:key?)
        url = item[:value]
        alt = item[:alt]
      else
        url = item
        alt = nil
      end

      if url.start_with?(ENV['ASSETS_URL'])
        associate_existing_asset(url, alt, attrs)
      else
        a << { file_remote_url: url, alt: alt }
      end
    end
  end

  def associate_existing_asset(url, alt, attrs)
    asset = find_asset_by_filename(file_id(url))
    attrs[:asset_ids] ||= []
    attrs[:asset_ids] << asset.id if asset
    Asset.update(alt: alt) if alt
  end

  def file_id(url)
    URI(url).path.delete_prefix('/')
  end

  def find_asset_by_filename(filename)
    Asset.where('file_data @> ?', { id: filename }.to_json).first
  end

  def create_asset(file)
    @asset = Asset.new(file: file)
    if @asset.save
      head :created, location: @asset.file_url
    else
      render json: { error: 'invalid_request', error_description: @asset.errors.full_messages }.to_json
    end
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

  def media_params
    params.permit(:file)
  end

  def post_params_form_encoded
    params[:category] = Array(params[:category]) if params.key?(:category)
    params[:photo] = Array(params[:photo]) if params.key?(:photo)
    params.permit(:content, category: [], photo: [])
  end

  def post_params_json
    params.permit(type: [], properties: {})
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
