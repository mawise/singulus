# frozen_string_literal: true

# Sends a webmention.
class SendWebmention
  # An exception that occurs when sending a webmention.
  class Error < StandardError
    attr_reader :response

    def initialize(message, response)
      super(message)
      @response = response
    end
  end

  attr_reader :webmention, :endpoint, :last_response

  def initialize(webmention)
    @webmention = webmention
  end

  def call
    discover_endpoint
    send_webmention
    update_webmention_success
  rescue HTTP::Error, Error => e
    Rails.logger.error(
      "Error sending webmention from #{webmention.source_url} to #{webmention.target_url}: #{e.message}"
    )
    update_webmention_error(e)
    raise
  end

  private

  USER_AGENT = 'Singulus/1.0 (https://tonyburns.io)'

  def discover_endpoint
    # Retrieve target
    response = fetch_target

    # Get links from headers
    links = find_links_from_headers(response)

    # Get links from document
    links += find_links_from_html(parse_html(response))

    # Parse endpoints from links
    endpoints = parse_endpoints(links, response)

    # Use first valid endpoint from links or document or target_url if no endpoints found
    @endpoint = endpoints.first || webmention.target_url
  end

  def send_webmention
    params = { source: webmention.source_url, target: webmention.target_url }
    @last_response = response = HTTP.headers('User-Agent': USER_AGENT).post(endpoint, form: params)
    raise_if_response_unsuccessful('Error sending webmention to endpoint')
    response
  end

  def fetch_target
    @last_response = response = HTTP.follow.headers('User-Agent': USER_AGENT).get(webmention.target_url)
    raise_if_response_unsuccessful('Error fetching target URL for endpoint discovery')
    response
  end

  def find_links_from_headers(response)
    response.headers.get('link')
  end

  def find_links_from_html(document)
    document.xpath("//*[self::link or self::a][contains(concat(' ',normalize-space(@rel),' '),' webmention ')]")
            .map { |tag| tag.attribute('href')&.to_s }
            .compact
            .reject(&:blank?)
            .map { |href| %(<#{href}>; rel="webmention") } # Convert to header format so everything gets parsed the same
  end

  def parse_html(response)
    Nokogiri::HTML(response.body.to_s)
  end

  def parse_endpoints(links, response)
    parsed = Array(LinkHeaderParser.parse(links, base: response.uri.to_s).group_by_relation_type[:webmention])
    parsed.each_with_object([]) { |link, endpoints| endpoints << link.target_uri }
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
