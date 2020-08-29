# frozen_string_literal: true

# Promotes a photo in storage and creates derivatives.
class PhotoPromoteWorker < ApplicationWorker
  sidekiq_options retries: 10, lock: :while_executing, on_conflict: :reschedule, queue: 'photo'

  def perform(id)
    photo = Photo.find(id)
    attacher = photo.file_attacher
    attacher.create_derivatives(:thumbnail)
    attacher.atomic_promote
  rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
    Rails.logger.warn "Attachment has changed or record has been deleted for photo #{id}"
  end
end
