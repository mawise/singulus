# frozen_string_literal: true

module Micropub
  # Creates a post from JSON.
  class CreatePostJSON < CreatePost
    def call(params)
      super

      params = params.dup.deep_symbolize_keys
      attrs = transform_json_properties(params[:properties].to_h)
      attrs[:categories] = attrs.delete(:category)

      photos = attrs.delete(:photo) || []
      attrs[:photos_attributes] = transform_json_photos(photos, attrs)

      create_post(attrs)
    end

    private

    FIRST_VALUE_ONLY = %i[content].freeze

    def transform_json_properties(props)
      props.deep_symbolize_keys.each_with_object({}) do |(k, v), h|
        h[k] = if FIRST_VALUE_ONLY.include?(k)
                 v.first
               else
                 v
               end
      end
    end

    def transform_json_photos(photos, attrs) # rubocop:disable Metrics/MethodLength
      photos.each_with_object([]) do |item, a|
        if item.respond_to?(:key?)
          url = item[:value]
          alt = item[:alt]
        else
          url = item
          alt = nil
        end

        if existing_asset?(url)
          associate_existing_photo(url, alt, attrs)
        else
          a << { file_remote_url: url, alt: alt }
        end
      end
    end
  end
end
