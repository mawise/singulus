# frozen_string_literal: true

# Sends a webmention.
class SendWebmention
  DEFAULT_USER_AGENT = 'Singulus/1.0 (Webmention; +https://tonyburns.net)'

  # An exception that occurs when sending a webmention.
  class Error < StandardError
    attr_reader :response

    def initialize(message, response)
      super(message)
      @response = response
    end
  end

  attr_reader :webmention, :endpoint, :last_response

  delegate :source_url, :target_url, to: :webmention

  def initialize(webmention, logger: Rails.logger, user_agent: DEFAULT_USER_AGENT)
    @webmention = webmention
    @logger = logger
    @user_agent = user_agent
  end

  def call
    logger.info("No webmention endpoint found for #{target_url}") && return unless discover_endpoint

    send_webmention
    update_webmention_success
  rescue HTTP::Error, Error => e
    logger.error("Error sending webmention from #{source_url} to #{target_url}: #{e.message}")
    update_webmention_error(e)
    raise
  end

  private

  attr_reader :logger, :user_agent

  def discover_endpoint
    @endpoint = DiscoverWebmentionEndpoint.new(target_url).call
  end

  def send_webmention
    params = { source: source_url, target: target_url }
    @last_response = response = HTTP.headers('User-Agent': user_agent).post(endpoint, form: params)
    raise_if_response_unsuccessful('Error sending webmention to endpoint')
    response
  end

  def update_webmention_success
    webmention.update(status: 'sent', sent_at: Time.zone.now, url: last_response.headers['Location'])
  end

  def update_webmention_error(err)
    webmention.update(status: 'error', status_info: err.message)
  end

  def raise_if_response_unsuccessful(msg)
    raise Error.new("#{msg}: #{last_response.status}", last_response) unless last_response.status.success?
  end
end
