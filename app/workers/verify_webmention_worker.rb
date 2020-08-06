# frozen_string_literal: true

# Verifies an incoming webmention.
class VerifyWebmentionWorker < ApplicationWorker
  sidekiq_options retries: 10, lock: :while_executing, on_conflict: :reschedule, queue: 'webmention'

  def perform(id)
    @webmention = Webmention.find(id)

    resp = Net::HTTP.get(@webmention.source_uri)
    props = Microformats.parse(resp).to_h

    @webmention.update!(status: 'verified', verified_at: Time.now.utc, source_properties: props)
  end
end
