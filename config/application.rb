# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Singulus
  # The Singulus Rails application.
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.middleware.use Rack::Attack

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.x.github.token = ENV.fetch('GITHUB_TOKEN')
    config.x.github.branch = ENV.fetch('GITHUB_BRANCH')
    config.x.github.repo = ENV.fetch('GITHUB_REPO')

    config.site_name = ENV.fetch('SITE_NAME')
    config.site_url = ENV.fetch('SITE_URL')
  end
end
