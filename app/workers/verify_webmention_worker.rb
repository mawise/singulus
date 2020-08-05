# frozen_string_literal: true

# Verifies an incoming webmention.
class VerifyWebmentionWorker < ApplicationWorker
  sidekiq_options retries: 10, lock: :while_executing, on_conflict: :reschedule, queue: 'webmention'

  def perform(id)
    @webmention = Webmention.find(id)
  end
end
