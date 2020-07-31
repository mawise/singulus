# frozen_string_literal: true

# Represents an asset (photo, video, audio, etc.) attached to a post.
class Asset < ApplicationRecord
  belongs_to :post, optional: true

  include AssetUploader::Attachment(:file)

  delegate :size, :metadata, :mime_type, to: :file

  def audio?
    mime_type.start_with?('audio/')
  end

  def image?
    mime_type.start_with?('image/')
  end

  def video?
    mime_type.start_with?('video/')
  end
end
