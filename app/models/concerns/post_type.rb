# frozen_string_literal: true

# Helpers for determining an post's post type.
module PostType
  extend ActiveSupport::Concern

  included do
    after_validation :cache_post_type
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
