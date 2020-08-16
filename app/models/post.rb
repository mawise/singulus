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
# **`categories`**    | `text`             | `default([]), is an Array`
# **`content`**       | `text`             |
# **`name`**          | `text`             |
# **`properties`**    | `jsonb`            | `not null`
# **`published_at`**  | `datetime`         |
# **`short_uid`**     | `text`             |
# **`slug`**          | `text`             |
# **`summary`**       | `text`             |
# **`url`**           | `text`             |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`author_id`**     | `uuid`             | `not null`
#
# ### Indexes
#
# * `index_posts_on_author_id`:
#     * **`author_id`**
# * `index_posts_on_categories` (_using_ gin):
#     * **`categories`**
# * `index_posts_on_properties` (_using_ gin):
#     * **`properties`**
# * `index_posts_on_published_at`:
#     * **`published_at`**
# * `index_posts_on_short_uid` (_unique_):
#     * **`short_uid`**
# * `index_posts_on_slug` (_unique_):
#     * **`slug`**
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
