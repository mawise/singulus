# frozen_string_literal: true

module Micropub
  # Base class for post creation.
  class CreatePost
    ALLOWED_PROPERTIES = %i[
      category
      content
      name
      photo
      summary
    ].freeze

    def call(params)
      @author_id = params.delete(:author_id)
    end

    protected

    attr_reader :author_id

    def create_post(attrs)
      post = Post.new(attrs)
      post.author_id = author_id
      post.published_at = Time.now.utc
      PublishWorker.perform_async('create', post.id) if post.save_unique
      post
    end

    def existing_asset?(url)
      url.start_with?(assets_url)
    end

    def associate_existing_photo(url, alt, attrs)
      photo = find_photo_by_filename(file_id(url))
      attrs[:photo_ids] ||= []
      attrs[:photo_ids] << photo.id if photo
      Photo.update(alt: alt) if alt
    end

    def file_id(url)
      Pathname.new(URI(url).path.delete_prefix(URI(assets_url).path)).basename.to_s
    end

    def find_photo_by_filename(filename)
      Photo.where('file_data @> ?', { id: filename }.to_json).first
    end

    def assets_url
      @assets_url ||= Rails.configuration.x.assets.url
    end
  end
end
