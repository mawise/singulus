# frozen_string_literal: true

# Represents a [post](https://indieweb.org/post).
#
# ## Schema Information
#
# Table name: `posts`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `uuid`             | `not null, primary key`
# **`categories`**             | `text`             | `default([]), is an Array`
# **`content`**                | `text`             |
# **`content_html`**           | `text`             |
# **`location`**               | `jsonb`            |
# **`meta_description`**       | `text`             |
# **`name`**                   | `text`             |
# **`og_description`**         | `text`             |
# **`og_image`**               | `text`             |
# **`og_locale`**              | `text`             |
# **`og_title`**               | `text`             |
# **`og_type`**                | `text`             |
# **`og_url`**                 | `text`             |
# **`properties`**             | `jsonb`            | `not null`
# **`published_at`**           | `datetime`         |
# **`rsvp`**                   | `integer`          |
# **`short_uid`**              | `text`             |
# **`slug`**                   | `text`             |
# **`summary`**                | `text`             |
# **`syndications`**           | `text`             | `is an Array`
# **`twitter_card`**           | `text`             |
# **`twitter_creator`**        | `text`             |
# **`twitter_description`**    | `text`             |
# **`twitter_image`**          | `text`             |
# **`twitter_image_alt`**      | `text`             |
# **`twitter_player`**         | `text`             |
# **`twitter_player_height`**  | `integer`          |
# **`twitter_player_stream`**  | `text`             |
# **`twitter_player_width`**   | `integer`          |
# **`twitter_site`**           | `text`             |
# **`twitter_title`**          | `text`             |
# **`type`**                   | `text`             |
# **`url`**                    | `text`             |
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
# **`author_id`**              | `uuid`             | `not null`
# **`featured_id`**            | `uuid`             |
# **`twitter_creator_id`**     | `text`             |
# **`twitter_site_id`**        | `text`             |
#
# ### Indexes
#
# * `index_posts_on_author_id`:
#     * **`author_id`**
# * `index_posts_on_categories` (_using_ gin):
#     * **`categories`**
# * `index_posts_on_featured_id`:
#     * **`featured_id`**
# * `index_posts_on_location` (_using_ gin):
#     * **`location`**
# * `index_posts_on_properties` (_using_ gin):
#     * **`properties`**
# * `index_posts_on_published_at`:
#     * **`published_at`**
# * `index_posts_on_rsvp`:
#     * **`rsvp`**
# * `index_posts_on_short_uid` (_unique_):
#     * **`short_uid`**
# * `index_posts_on_slug` (_unique_):
#     * **`slug`**
# * `index_posts_on_syndications` (_using_ gin):
#     * **`syndications`**
# * `index_posts_on_type`:
#     * **`type`**
# * `index_posts_on_url`:
#     * **`url`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`author_id => users.id`**
# * `fk_rails_...`:
#     * **`featured_id => photos.id`**
#
class Post < ApplicationRecord
  include Citations
  include FrontMatter
  include Metadata
  include OpenGraphMetadata
  include TwitterMetadata
  include Type
  include Webmentions

  include ShortUID

  self.inheritance_column = nil

  enum rsvp: { yes: 0, no: 1, maybe: 2, interested: 3 }, _prefix: :rsvp

  searchkick

  belongs_to :author, class_name: 'User', inverse_of: :posts

  belongs_to :featured, class_name: 'Photo', inverse_of: :posts_as_featured, optional: true

  has_many :links, as: :resource, inverse_of: :resource, dependent: :nullify

  has_many :photos, dependent: :nullify
  accepts_nested_attributes_for :photos, allow_destroy: true,
                                         reject_if: proc { |a| a['file'].blank? && a['file_remote_url'].blank? }

  validates :slug, presence: true, uniqueness: { case_sensitive: true }

  before_validation :generate_slug, on: :create

  def self.republish_all!
    all.find_each(&:republish!)
  end

  def republish!(action: 'update')
    HugoPublishWorker.perform_async(action, id)
  end

  def category_names
    Array(categories).join(', ')
  end

  def category_names=(val)
    self.categories = val.strip.gsub(/\s+/, ' ').split(',').map(&:strip)
  end

  def published?
    published_at.present?
  end

  def draft?
    published_at.blank?
  end

  private

  def generate_slug
    return if slug.present?

    self.slug = if name.present?
                  name.parameterize
                else
                  short_uid
                end
  end
end
