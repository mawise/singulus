# frozen_string_literal: true

# Represents a photo attached to a Post.
#
# ## Schema Information
#
# Table name: `photos`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `uuid`             | `not null, primary key`
# **`alt`**         | `text`             |
# **`file_data`**   | `jsonb`            |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
class Photo < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true, touch: true

  has_many :attachments, as: :attachable, inverse_of: :attachable, dependent: :destroy
  has_many :posts, through: :attachments, source: :attacher, source_type: 'Post'
  has_many :users, through: :attachments, source: :attacher, source_type: 'User'

  has_many :links, as: :resource, inverse_of: :resource, dependent: :nullify

  include PhotoUploader::Attachment(:file, store: :photo)

  delegate :size, :metadata, :mime_type, to: :file

  def create_meta_images!
    file_attacher.create_derivatives(:open_graph) if open_graph_url.blank?
    file_attacher.create_derivatives(:twitter_card) if twitter_card_url.blank?
    file_attacher.atomic_promote
  end

  def aspect_ratio
    file.metadata['width'].to_f / file.metadata['height']
  end

  def width(derivative = nil)
    derivative ? file_data.dig('derivatives', derivative.to_s, 'metadata', 'width') : file.metadata['width']
  end

  def height(derivative = nil)
    derivative ? file_data.dig('derivatives', derivative.to_s, 'metadata', 'height') : file.metadata['height']
  end

  def thumbnail_url
    file_url(:thumbnail) || file_url
  end

  def open_graph_url
    file_url(:open_graph)
  end

  def open_graph_height
    height(:open_graph)
  end

  def open_graph_width
    width(:open_graph)
  end

  def twitter_card_url
    file_url(:twitter_card)
  end

  def twitter_card_height
    height(:twitter_card)
  end

  def twitter_card_width
    width(:twitter_card)
  end

  def wilson_list_url
    file_url(:wilson_list)
  end

  def wilson_post_url
    file_url(:wilson_post)
  end

  def as_front_matter_json
    {
      url: file_url,
      open_graph_url: open_graph_url,
      twitter_card_url: twitter_card_url,
      wilson_list_url: wilson_list_url,
      wilson_post_url: wilson_post_url,
      alt: alt
    }
  end
end
