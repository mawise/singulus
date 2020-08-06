# frozen_string_literal: true

# Verifies an incoming webmention.
class VerifyWebmentionWorker < ApplicationWorker
  sidekiq_options retries: 10, lock: :while_executing, on_conflict: :reschedule, queue: 'webmention'

  def perform(id)
    @webmention = Webmention.find(id)

    resp = Net::HTTP.get(@webmention.source_uri)
    props = Microformats.parse(resp).to_h
  end

  private

  def retrieve_source
    req = Typhoeus::Request.new(@webmention.source_url, followlocation: true)
    req.on_complete do |res|
    end
    req.run
  end
end
