# frozen_string_literal: true

class Post < ApplicationRecord
  # Helpers for generating Open Graph metadata for a post.
  module OpenGraphMetadata
    extend ActiveSupport::Concern

    def opengraph_metadata
      %i[title url image image_height image_width type description locale].each_with_object({}) do |prop, h|
        h[:"og_#{prop}"] = send(prop.to_s.prepend('og_').to_sym)
      end
    end

    def og_title
      return super if self[:og_title]

      name.presence || Rails.configuration.x.site.name
    end

    def og_url
      self[:og_url] || permalink_url
    end

    def og_image
      return super if self[:og_image]

      return featured.opengraph_url if featured.present?

      author.opengraph_photo_url
    end

    def og_image_width
      return photos.first.opengraph_width if type == 'photo'
      return featured.opengraph_width if featured.present?

      author.photo&.opengraph_width
    end

    def og_image_height
      return photos.first.opengraph_height if type == 'photo'
      return featured.opengraph_height if featured.present?

      author.photo&.opengraph_height
    end

    def og_type # rubocop:disable Metrics/MethodLength
      return super if self[:og_type]

      case type
      when 'audio'
        'music.song'
      when 'video'
        'video.other'
      when 'article', 'note', 'like', 'repost', 'bookmark', 'rsvp', 'photo'
        'article'
      else
        'website'
      end
    end

    def og_description
      self[:og_description] || meta_description
    end

    def og_locale
      return super if self[:og_locale]

      'en_US'
    end
  end
end
