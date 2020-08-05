# frozen_string_literal: true

# == Schema Information
#
# Table name: photos
#
#  id         :uuid             not null, primary key
#  alt        :text
#  duration   :interval
#  file_data  :jsonb
#  metadata   :hstore           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :uuid
#
# Indexes
#
#  index_photos_on_metadata  (metadata) USING gin
#  index_photos_on_post_id   (post_id)
#
# Represents a photo asset.
class Photo < ApplicationRecord
  belongs_to :post, optional: true

  has_many :shortlinks, as: :resource, dependent: :nullify

  include PhotoUploader::Attachment(:file)

  delegate :size, :metadata, :mime_type, to: :file
end
