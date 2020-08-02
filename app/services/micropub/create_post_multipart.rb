# frozen_string_literal: true

module Micropub
  # Creates a post from form encoded parameters.
  class CreatePostMultipart < CreatePost
    def call(params)
      super

      attrs = params.deep_symbolize_keys
      attrs[:categories] = attrs.delete(:category)

      photos = attrs.delete(:photo) || []
      transform_photos_form_encoded(photos, attrs)

      create_post(attrs)
    end

    private

    def transform_photos_form_encoded(photos, attrs)
      attrs[:photos_attributes] = photos.each_with_object([]) do |upload, a|
        if upload.is_a?(String) && existing_asset?(upload)
          associate_existing_photo(upload, nil, attrs)
        elsif upload.is_a?(String)
          a.append({ file_remote_url: upload })
        else
          a.append({ file: upload })
        end
      end
    end
  end
end
