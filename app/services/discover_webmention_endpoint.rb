# frozen_string_literal: true

# Discovers the webmention endpoint for a given URL.
#
# Conformant with https://webmention.net/draft/#sender-discovers-receiver-webmention-endpoint
class DiscoverWebmentionEndpoint
  DEFAULT_USER_AGENT = 'Singulus/1.0 (Webmention; +https://tonyburns.net)'

  # An exception that occurs when discovering a webmention endpoint.
  class Error < StandardError
    attr_reader :response

    def initialize(message, response)
      super(message)
      @response = response
    end
  end

  attr_reader :target_url, :last_response

  def initialize(target_url, logger: Rails.logger, user_agent: DEFAULT_USER_AGENT)
    @target_url = target_url
    @logger = logger
    @user_agent = user_agent
  end

  def call
    # Retrieve the target URL of the webmention
    response = fetch_target

    # Get links from headers
    links = find_links_from_headers(response)

    # Get links from document
    links += find_links_from_html(parse_html(response), target_url)

    # Parse endpoints from links
    endpoints = parse_endpoints(links, response)

    # Use first valid endpoint from links or document or return nil if no endpoints found
    endpoints.first
  rescue HTTP::Error, Error => e
    logger.error(
      "Error discovering webmention endpoint for #{target_url}: #{e.message}"
    )
    raise
  end

  private

  attr_reader :logger, :user_agent

  def fetch_target
    @last_response = response = HTTP.follow.headers('User-Agent': user_agent).get(target_url)
    raise_if_response_unsuccessful('Error fetching target URL for endpoint discovery')
    response
  end

  def find_links_from_headers(response)
    response.headers.get('link')
  end

  def find_links_from_html(document, default_href)
    document.xpath("//*[self::link or self::a][contains(concat(' ',normalize-space(@rel),' '),' webmention ')]")
            .map { |tag| tag.attribute('href')&.to_s }
            .compact
            .map { |href| href.strip.empty? ? default_href : href }
            .map { |href| %(<#{href}>; rel="webmention") } # Convert to header format so everything gets parsed the same
  end

  def parse_html(response)
    Nokogiri::HTML(response.body.to_s)
  end

  def parse_endpoints(links, response)
    parsed = Array(LinkHeaderParser.parse(links, base: response.uri.to_s).group_by_relation_type[:webmention])
    parsed.each_with_object([]) { |link, endpoints| endpoints << link.target_uri }
  end

  def raise_if_response_unsuccessful(msg)
    raise Error.new("#{msg}: #{last_response.status}", last_response) unless last_response.status.success?
  end
end
