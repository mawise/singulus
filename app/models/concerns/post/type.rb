# frozen_string_literal: true

class Post < ApplicationRecord
  # Helpers for determining an post's post type.
  module Type
    extend ActiveSupport::Concern

    included do
      after_validation :cache_post_type

      scope :articles, -> { where(type: 'article') }
      scope :bookmarks, -> { where(type: 'bookmark') }
      scope :likes, -> { where(type: 'like') }
      scope :notes, -> { where(type: 'note') }
      scope :replies, -> { where(type: 'reply') }
      scope :reposts, -> { where(type: 'repost') }
      scope :rsvps, -> { where(type: 'rsvp') }
    end

    def permalink_url
      prefix = Rails.configuration.x.site.url
      "#{prefix}/#{type.pluralize}/#{slug}"
    end

    def hugo_source_path
      "content/#{type.pluralize}/#{id}.md"
    end

    private

    def cache_post_type
      self.type = PostTypeDiscovery.new.call(self)
    end
  end
end
