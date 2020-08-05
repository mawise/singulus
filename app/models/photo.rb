# frozen_string_literal: true

# Represents a photo asset.
class Photo < ApplicationRecord
  belongs_to :post, optional: true

  has_many :shortlinks, as: :resource, dependent: :nullify

  include PhotoUploader::Attachment(:file)

  delegate :size, :metadata, :mime_type, to: :file
end
