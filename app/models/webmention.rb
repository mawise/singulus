# frozen_string_literal: true

# Represents a [Webmention](https://indieweb.org/webmention).
#
# ## Schema Information
#
# Table name: `webmentions`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `uuid`             | `not null, primary key`
# **`approved_at`**        | `datetime`         |
# **`deleted_at`**         | `datetime`         |
# **`received_at`**        | `datetime`         |
# **`sent_at`**            | `datetime`         |
# **`short_uid`**          | `text`             | `not null`
# **`source_properties`**  | `jsonb`            | `not null`
# **`source_url`**         | `text`             | `not null`
# **`status`**             | `text`             | `default("pending"), not null`
# **`status_info`**        | `jsonb`            | `not null`
# **`target_url`**         | `text`             | `not null`
# **`url`**                | `text`             |
# **`verified_at`**        | `datetime`         |
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`source_id`**          | `uuid`             |
# **`target_id`**          | `uuid`             |
#
# ### Indexes
#
# * `index_webmentions_on_received_at`:
#     * **`received_at`**
# * `index_webmentions_on_sent_at`:
#     * **`sent_at`**
# * `index_webmentions_on_source_id`:
#     * **`source_id`**
# * `index_webmentions_on_source_id_and_target_id` (_unique_):
#     * **`source_id`**
#     * **`target_id`**
# * `index_webmentions_on_source_properties` (_using_ gin):
#     * **`source_properties`**
# * `index_webmentions_on_source_url_and_target_id` (_unique_):
#     * **`source_url`**
#     * **`target_id`**
# * `index_webmentions_on_source_url_and_target_url` (_unique_):
#     * **`source_url`**
#     * **`target_url`**
# * `index_webmentions_on_status`:
#     * **`status`**
# * `index_webmentions_on_target_id`:
#     * **`target_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`source_id => posts.id`**
# * `fk_rails_...`:
#     * **`target_id => posts.id`**
#
class Webmention < ApplicationRecord
  include ShortUID

  belongs_to :source, class_name: 'Post', inverse_of: :webmentions_as_source, optional: true
  belongs_to :target, class_name: 'Post', inverse_of: :webmentions_as_target, optional: true

  validates :source_url, presence: true, url: { schemes: %w[http https] }
  validates :target_url, presence: true, url: { schemes: %w[http https] }

  validate :source_url_and_target_url_cannot_be_the_same

  scope :approved, -> { where(status: 'approved') }
  scope :denied, -> { where(status: 'denied') }
  scope :verified, -> { where(status: 'verified') }
  scope :pending, -> { where(status: 'pending') }

  scope :incoming, -> { where.not(target_id: nil) }
  scope :outgoing, -> { where.not(source_id: nil) }
  scope :local, -> { where.not(target_id: nil, source_id: nil) }

  def send_to_target!
    SendWebmention.new(self).call
  end

  def source_uri
    URI(source_url) if source_url.present?
  end

  def target_uri
    URI(target_url) if target_url.present?
  end

  def as_front_matter_json
    {
      source: source_url,
      target: target_url,
      properties: source_properties,
      created_at: created_at
    }
  end

  private

  def source_url_and_target_url_cannot_be_the_same
    errors.add(:source_url_and_target_url, "can't be the same") if source_url == target_url
  end
end
