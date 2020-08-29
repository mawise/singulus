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
# **`published_at`**           | `datetime`         |
# **`rsvp`**                   | `integer`          |
# **`short_uid`**              | `text`             |
# **`slug`**                   | `text`             |
# **`summary`**                | `text`             |
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
# **`twitter_creator_id`**     | `text`             |
# **`twitter_site_id`**        | `text`             |
#
# ### Indexes
#
# * `index_posts_on_author_id`:
#     * **`author_id`**
# * `index_posts_on_categories` (_using_ gin):
#     * **`categories`**
# * `index_posts_on_location` (_using_ gin):
#     * **`location`**
# * `index_posts_on_published_at`:
#     * **`published_at`**
# * `index_posts_on_rsvp`:
#     * **`rsvp`**
# * `index_posts_on_short_uid` (_unique_):
#     * **`short_uid`**
# * `index_posts_on_slug` (_unique_):
#     * **`slug`**
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

  belongs_to :author, class_name: 'User', inverse_of: :posts

  has_many :photo_attachments, -> { where(rel: 'photo') },
           class_name: 'Attachment', as: :attacher, inverse_of: :attacher, dependent: :destroy
  has_many :photos, through: :photo_attachments, source: :attachable, source_type: 'Photo'
  accepts_nested_attributes_for :photo_attachments, allow_destroy: true,
                                                    reject_if: :invalid_attachment_attributes?

  has_many :featured_photo_attachments, -> { where(rel: 'featured') },
           class_name: 'Attachment', as: :attacher, inverse_of: :attacher, dependent: :destroy
  has_many :featured_photos, through: :featured_photo_attachments, source: :attachable, source_type: 'Photo'
  accepts_nested_attributes_for :featured_photo_attachments, allow_destroy: true,
                                                             reject_if: :invalid_attachment_attributes?

  has_many :links, as: :resource, inverse_of: :resource, dependent: :nullify

  validates :slug, presence: true, uniqueness: { case_sensitive: true }

  before_validation :generate_slug, on: :create

  def self.republish_all!
    all.find_each(&:republish!)
  end

  def featured
    featured_photos.first
  end

  def republish!
    HugoPublishWorker.perform_async(id)
  end

  def category_names
    Array(categories).join(', ')
  end

  def category_names=(val)
    self.categories = val.strip.gsub(/\s+/, ' ').split(',').map(&:strip)
  end

  def photo_attachments_attributes=(attrs)
    if attrs.respond_to?(:permitted)
      attrs.transform_values! { |v| v.merge(attachable_type: 'Photo', rel: 'photo') }
    elsif attrs.is_a?(Array)
      attrs.map! { |v| v.merge(attachable_type: 'Photo', rel: 'photo') }
    end
    super
  end

  def featured_photo_attachments_attributes=(attrs)
    if attrs.respond_to?(:permitted)
      attrs.transform_values! { |v| v.merge(attachable_type: 'Photo', rel: 'featured') }
    elsif attrs.is_a?(Array)
      attrs.map { |v| v.merge(attachable_type: 'Photo', rel: 'featured') }
    end
    super
  end

  def published?
    published_at.present?
  end

  def draft?
    published_at.blank?
  end

  private

  def invalid_attachment_attributes?(attrs)
    attrs[:attachable_id].blank? &&
      attrs.dig(:attachable_attributes, :file).blank? &&
      attrs.dig(:attachable_attributes, :file_remote_url).blank?
  end

  def generate_slug
    return if slug.present?

    self.slug = if name.present?
                  name.parameterize
                else
                  short_uid
                end
  end
end
