# frozen_string_literal: true

# Represents a shortened URL.
#
# ## Schema Information
#
# Table name: `links`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`id`**             | `uuid`             | `not null, primary key`
# **`expires_in`**     | `integer`          |
# **`name`**           | `text`             | `not null`
# **`resource_type`**  | `string`           |
# **`tags`**           | `text`             | `default([]), not null, is an Array`
# **`target_url`**     | `text`             | `not null`
# **`title`**          | `text`             |
# **`created_at`**     | `datetime`         | `not null`
# **`updated_at`**     | `datetime`         | `not null`
# **`resource_id`**    | `uuid`             |
#
# ### Indexes
#
# * `index_links_on_name` (_unique_):
#     * **`name`**
# * `index_links_on_resource_id_and_resource_type`:
#     * **`resource_id`**
#     * **`resource_type`**
# * `index_links_on_resource_type_and_resource_id`:
#     * **`resource_type`**
#     * **`resource_id`**
# * `index_links_on_tags` (_using_ gin):
#     * **`tags`**
# * `index_links_on_target_url`:
#     * **`target_url`**
#
class Link < ApplicationRecord
  include Doorkeeper::Models::Expirable

  LINK_REGEX = /\A[a-zA-Z0-9_\-]+\z/.freeze

  belongs_to :resource, polymorphic: true, optional: true

  validates :name, presence: true, uniqueness: { case_sensitive: true }, format: { with: LINK_REGEX }
  validates :target_url, presence: true, url: true

  before_validation :generate_short_uid, on: :create

  def tag_names
    tags.join(', ')
  end

  def tag_names=(val)
    self.tags = val.strip.gsub(/\s+/, ' ').split(',').map(&:strip)
  end

  def save_unique
    on_retry = proc do |_, _try, _, _|
      Rails.logger.info('Collison generating link, trying again')
    end
    Retriable.retriable on: [ActiveRecord::RecordNotUnique], on_retry: on_retry do
      save
    end
  end

  def target_uri
    URI(target_url)
  end

  private

  def generate_short_uid
    self.name = SecureRandom.uuid[0..5] if name.blank?
  end
end
