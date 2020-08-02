# frozen_string_literal: true

module Micropub
  # Provides  Micropub [create](https://micropub.spec.indieweb.org/#create),
  # [update](https://micropub.spec.indieweb.org/#update), and
  # [delete](https://micropub.spec.indieweb.org/#delete) endpoints.
  class PostsController < MicropubController # rubocop:disable Metrics/ClassLength
    def create
      case request.media_type
      when 'application/x-www-form-urlencoded', 'multipart/form-data'
        handle_form_encoded
      when 'application/json'
        handle_json
      else
        handle_unsupported_media_type
      end
    end

    private

    FIRST_VALUE_ONLY = %i[content].freeze

    def handle_form_encoded
      attrs = post_params_form_encoded
      attrs[:categories] = attrs.delete(:category)

      photos = attrs.delete(:photo) || []
      transform_photos_form_encoded(photos, attrs)

      attrs.delete(:category)
      create_post(attrs)
    end

    def transform_photos_form_encoded(photos, attrs)
      attrs[:photos_attributes] = photos.each_with_object([]) do |upload, a|
        if upload.is_a?(String) && upload.start_with?(assets_url)
          associate_existing_photo(upload, nil, attrs)
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
      attrs[:photos_attributes] = transform_json_photos(attrs)
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

    def transform_json_photos(attrs) # rubocop:disable Metrics/MethodLength
      (attrs.delete(:photo) || []).each_with_object([]) do |item, a|
        if item.respond_to?(:key?)
          url = item[:value]
          alt = item[:alt]
        else
          url = item
          alt = nil
        end

        if url.start_with?(assets_url)
          associate_existing_photo(url, alt, attrs)
        else
          a << { file_remote_url: url, alt: alt }
        end
      end
    end

    def associate_existing_photo(url, alt, attrs)
      photo = find_photo_by_filename(file_id(url))
      attrs[:photo_ids] ||= []
      attrs[:photo_ids] << photo.id if photo
      Photo.update(alt: alt) if alt
    end

    def file_id(url)
      URI(url).path.delete_prefix(URI(assets_url).path)
    end

    def find_photo_by_filename(filename)
      Photo.where('file_data @> ?', { id: filename }.to_json).first
    end

    def create_post(attrs)
      @post = Post.new(attrs)
      @post.author_id = doorkeeper_token.resource_owner_id
      @post.published_at = Time.now.utc
      if save_post
        PublishWorker.perform_async('create', @post.id)
        head :accepted, location: @post.permalink_url
      else
        render json: { error: 'invalid_request', error_description: @post.errors.full_messages }.to_json, status: :bad_request # rubocop:disable Layout/LineLength
      end
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

    def assets_url
      @assets_url ||= Rails.configuration.assets.url
    end
  end
end
