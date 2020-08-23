# frozen_string_literal: true

# Represents a [post](https://indieweb.org/post).
#
# ## Schema Information
#
# Table name: `posts`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `uuid`             | `not null, primary key`
# **`bookmark_of`**   | `jsonb`            |
# **`categories`**    | `text`             | `default([]), is an Array`
# **`content`**       | `text`             |
# **`content_html`**  | `text`             |
# **`featured`**      | `text`             |
# **`in_reply_to`**   | `jsonb`            |
# **`like_of`**       | `jsonb`            |
# **`location`**      | `jsonb`            |
# **`name`**          | `text`             |
# **`properties`**    | `jsonb`            | `not null`
# **`published_at`**  | `datetime`         |
# **`repost_of`**     | `jsonb`            |
# **`rsvp`**          | `integer`          |
# **`short_uid`**     | `text`             |
# **`slug`**          | `text`             |
# **`summary`**       | `text`             |
# **`syndications`**  | `text`             | `is an Array`
# **`type`**          | `text`             |
# **`url`**           | `text`             |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`author_id`**     | `uuid`             | `not null`
#
# ### Indexes
#
# * `index_posts_on_author_id`:
#     * **`author_id`**
# * `index_posts_on_bookmark_of` (_using_ gin):
#     * **`bookmark_of`**
# * `index_posts_on_categories` (_using_ gin):
#     * **`categories`**
# * `index_posts_on_in_reply_to` (_using_ gin):
#     * **`in_reply_to`**
# * `index_posts_on_like_of` (_using_ gin):
#     * **`like_of`**
# * `index_posts_on_location` (_using_ gin):
#     * **`location`**
# * `index_posts_on_properties` (_using_ gin):
#     * **`properties`**
# * `index_posts_on_published_at`:
#     * **`published_at`**
# * `index_posts_on_repost_of` (_using_ gin):
#     * **`repost_of`**
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
#
class Post < ApplicationRecord
  include PostType
  include ShortUID

  self.inheritance_column = nil

  enum rsvp: { yes: 0, no: 1, maybe: 2, interested: 3 }, _prefix: :rsvp

  store :bookmark_of, accessors: %i[url], coder: JSON, prefix: true
  store :in_reply_to, accessors: %i[url], coder: JSON, prefix: true
  store :like_of, accessors: %i[url], coder: JSON, prefix: true
  store :repost_of, accessors: %i[url], coder: JSON, prefix: true

  searchkick

  belongs_to :author, class_name: 'User'

  has_many :links, as: :resource, inverse_of: :resource, dependent: :nullify

  has_many :webmentions_as_source, foreign_key: :source_id,
                                   class_name: 'Webmention', inverse_of: :source, dependent: :nullify
  has_many :webmentions_as_target, foreign_key: :target_id,
                                   class_name: 'Webmention', inverse_of: :target, dependent: :nullify

  has_many :photos, dependent: :nullify
  accepts_nested_attributes_for :photos, allow_destroy: true,
                                         reject_if: proc { |a| a['file'].blank? && a['file_remote_url'].blank? }

  validates :slug, presence: true, uniqueness: { case_sensitive: true }

  before_validation :generate_slug, on: :create

  def category_names
    categories.join(', ')
  end

  def category_names=(val)
    self.categories = val.strip.gsub(/\s+/, ' ').split(',').map(&:strip)
  end

  def published?
    published_at.present?
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
