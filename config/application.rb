# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)

module Singulus
  # The Singulus Rails application.
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Additional middleware
    config.middleware.use Rack::Attack

    # Generator configuration
    config.generators.system_tests = nil

    # GitHub configuration
    config.x.github.token = ENV.fetch('GITHUB_TOKEN', '')
    config.x.github.branch = ENV.fetch('GITHUB_BRANCH', 'main')
    config.x.github.repo = ENV.fetch('GITHUB_REPO', '')

    # Site configuration
    config.x.site.name = ENV.fetch('SITE_NAME', 'Singulus')
    config.x.site.url = ENV.fetch('SITE_URL', 'https://example.com')

    # Hub configuration
    config.x.hub.host = ENV.fetch('SINGULUS_HOST', 'singulus.dev')

    # Link configuration
    config.x.links.host = ENV.fetch('LINKS_HOST', 'sngls.dev')

    # Hosts
    config.hosts << config.x.hub.host
    config.hosts << config.x.links.host
  end
end
