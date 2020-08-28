# frozen_string_literal: true

class Post < ApplicationRecord
  # Helpers for generating Twitter metadata for a post.
  module TwitterMetadata
    extend ActiveSupport::Concern

    def twitter_metadata
      %i[
        card site site_id creator creator_id title description
        image image_alt image_height image_width
      ].each_with_object({}) do |prop, h|
        h[:"twitter_#{prop}"] = send(prop.to_s.prepend('twitter_').to_sym)
      end
    end

    def twitter_card # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
      return super if self[:twitter_card]

      case type
      when 'audio', 'video'
        'player'
      when 'photo'
        photos.first.aspect_ratio.to_d == 1.0.to_d ? 'summary' : 'summary_large_image'
      else
        if featured.blank? || featured&.aspect_ratio.to_d == 1.0.to_d
          'summary'
        else
          'summary_large_image'
        end
      end
    end

    def twitter_site
      return super if self[:twitter_site]

      "@#{Rails.configuration.x.site.twitter_username}"
    end

    def twitter_site_id
      return super if self[:twitter_site_id]

      Rails.configuration.x.site.twitter_user_id
    end

    def twitter_creator
      return super if self[:twitter_creator]

      author.twitter_username.present? ? "@#{author.twitter_username}" : twitter_site
    end

    def twitter_creator_id
      return super if self[:twitter_creator_id]

      author.twitter_user_id || twitter_site_id
    end

    def twitter_title
      return super if self[:twitter_title]

      name.presence || Rails.configuration.x.site.name
    end

    def twitter_description
      self[:twitter_description] || meta_description
    end

    def twitter_image
      return super if self[:twitter_image]

      return photos.first.twitter_card_url if type == 'photo'

      return featured.twitter_card_url if featured.present?

      author.twitter_card_photo_url
    end

    def twitter_image_width
      return photos.first.twitter_card_width if type == 'photo'
      return featured.twitter_card_width if featured.present?

      author.photo&.twitter_card_width
    end

    def twitter_image_height
      return photos.first.twitter_card_height if type == 'photo'
      return featured.twitter_card_height if featured.present?

      author.photo&.twitter_card_height
    end

    def twitter_image_alt
      return super if self[:twitter_image_alt]

      return photos.first.alt if type == 'photo'

      return featured.alt if featured.present?

      author.name
    end
  end
end
