# frozen_string_literal: true

# Generates derivatives for a photo.
class ProcessPhotoDerivativesWorker < ApplicationWorker
  sidekiq_options retries: 10, lock: :while_executing, on_conflict: :reschedule, queue: 'photo_derivatives'

  def perform(id)
    @photo = Photo.find(id)
    @attacher = @photo.file_attacher
    @file = @photo.file

    process_downloads
  end

  private

  attr_reader :photo, :attacher, :file

  def process_downloads
    attacher.create_derivatives(:downloads)
  end
end
