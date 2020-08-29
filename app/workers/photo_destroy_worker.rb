# frozen_string_literal: true

# Destroys photos in storage.
class PhotoDestroyWorker < ApplicationWorker
  sidekiq_options retries: 10, lock: :while_executing, on_conflict: :reschedule, queue: 'photo'

  def perform(data)
    attacher = PhotoUploader::Attacher.from_data(data)
    attacher.destroy
  end
end
