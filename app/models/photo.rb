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
# **`duration`**    | `interval`         |
# **`file_data`**   | `jsonb`            |
# **`metadata`**    | `hstore`           | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`post_id`**     | `uuid`             |
#
# ### Indexes
#
# * `index_photos_on_metadata` (_using_ gin):
#     * **`metadata`**
# * `index_photos_on_post_id`:
#     * **`post_id`**
#
class Photo < ApplicationRecord
  belongs_to :post, optional: true

  has_many :links, as: :resource, inverse_of: :resource, dependent: :nullify

  has_many :posts_as_featured, class_name: 'Post', foreign_key: :featured_id, inverse_of: :featured, dependent: :nullify

  include PhotoUploader::Attachment(:file, store: :photo)

  delegate :size, :metadata, :mime_type, to: :file

  def as_front_matter_json
    {
      url: file_url,
      alt: alt
    }
  end
end
