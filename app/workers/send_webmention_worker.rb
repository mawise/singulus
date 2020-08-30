# frozen_string_literal: true

# Sends an outgoing webmention.
class SendWebmentionWorker < ApplicationWorker
  sidekiq_options retries: 10, lock: :while_executing, on_conflict: :reschedule, queue: 'webmention'

  def perform(id)
    Webmention.find(id).send_to_target!
  end
end
