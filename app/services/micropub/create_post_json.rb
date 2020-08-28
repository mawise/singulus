# frozen_string_literal: true

module Micropub
  # Creates a post from JSON.
  class CreatePostJSON < CreatePost
    def call(params)
      super

      params = params.dup.deep_symbolize_keys
      attrs = transform_json_properties(params[:properties].to_h)
      attrs.select! { |k, _| Micropub::CreatePost::ALLOWED_PROPERTIES.include?(k) }
      attrs[:categories] = attrs.delete(:category)

      photos = attrs.delete(:photo) || []
      attrs[:photo_attachments_attributes] = transform_json_photos(photos)

      create_post(attrs)
    end

    private

    FIRST_VALUE_ONLY = %i[
      content name summary
      featured
      bookmark_of in_reply_to like_of repost_of
    ].freeze

    def transform_json_properties(props)
      props.deep_symbolize_keys.each_with_object({}) do |(k, v), h|
        h[k] = if FIRST_VALUE_ONLY.include?(k)
                 v.first
               else
                 v
               end
      end
    end

    def transform_json_photos(photos) # rubocop:disable Metrics/MethodLength
      photos.each_with_object([]) do |item, a|
        if item.respond_to?(:key?)
          url = item[:value]
          alt = item[:alt]
        else
          url = item
          alt = nil
        end

        a << if existing_asset?(url)
               associate_existing_photo(url, alt)
             else
               { attachable_attributes: { file_remote_url: url, alt: alt } }
             end
      end
    end
  end
end
