# frozen_string_literal: true

# Represents a photo attached to a Post.
#
# ## Schema Information
#
# Table name: `photos`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `uuid`             | `not null, primary key`
# **`alt`**              | `text`             |
# **`attachable_rel`**   | `text`             |
# **`attachable_type`**  | `string`           |
# **`duration`**         | `interval`         |
# **`file_data`**        | `jsonb`            |
# **`metadata`**         | `hstore`           | `not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`attachable_id`**    | `uuid`             |
# **`post_id`**          | `uuid`             |
#
# ### Indexes
#
# * `attachable`:
#     * **`attachable_id`**
#     * **`attachable_type`**
#     * **`attachable_rel`**
# * `index_photos_on_attachable_type_and_attachable_id`:
#     * **`attachable_type`**
#     * **`attachable_id`**
# * `index_photos_on_metadata` (_using_ gin):
#     * **`metadata`**
# * `index_photos_on_post_id`:
#     * **`post_id`**
#
class Photo < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true, touch: true

  belongs_to :post, optional: true

  has_many :links, as: :resource, inverse_of: :resource, dependent: :nullify

  has_many :posts_as_featured, class_name: 'Post', foreign_key: :featured_id, inverse_of: :featured, dependent: :nullify

  has_one :user, class_name: 'User', inverse_of: :photo, dependent: :nullify

  include PhotoUploader::Attachment(:file, store: :photo)

  delegate :size, :metadata, :mime_type, to: :file

  after_create :create_derivatives!

  def create_derivatives!
    file_attacher.create_derivatives(:thumbnails)
    file_attacher.create_derivatives(:wilson)
    file_attacher.create_derivatives(:meta)
    save

    ProcessPhotoDerivativesWorker.perform_async(id)
  end

  def aspect_ratio
    file.metadata['width'].to_f / file.metadata['height']
  end

  def width(derivative = nil)
    derivative ? file_data['derivatives'][derivative.to_s]['metadata']['width'] : file.metadata['width']
  end

  def height(derivative = nil)
    derivative ? file_data['derivatives'][derivative.to_s]['metadata']['height'] : file.metadata['height']
  end

  def opengraph_url
    file_url(:opengraph)
  end

  def opengraph_height
    height(:opengraph)
  end

  def opengraph_width
    width(:opengraph)
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
      opengraph_url: opengraph_url,
      twitter_card_url: twitter_card_url,
      wilson_list_url: wilson_list_url,
      wilson_post_url: wilson_post_url,
      alt: alt
    }
  end
end
