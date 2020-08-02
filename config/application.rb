# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

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
    config.x.github.token = ENV.fetch('GITHUB_TOKEN')
    config.x.github.branch = ENV.fetch('GITHUB_BRANCH')
    config.x.github.repo = ENV.fetch('GITHUB_REPO')

    # Site configuration
    config.site_name = ENV.fetch('SITE_NAME')
    config.site_url = ENV.fetch('SITE_URL')
  end
end
