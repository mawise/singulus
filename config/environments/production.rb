# frozen_string_literal: true

Rails.application.configure do
  # General Rails configuration
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.eager_load = true

  # Public file server configuration
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Logging configuration
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = :debug
  config.log_tags = %i[request_id]

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Assets configuration
  config.assets.compile = false
  config.assets.url = ENV.fetch('ASSETS_URL')

  # ActionController configuration
  config.action_controller.perform_caching = true

  # ActionMailer configuration
  config.action_mailer.perform_caching = false

  # ActiveRecord configuration
  config.active_record.dump_schema_after_migration = false

  # ActiveSupport configuration
  config.active_support.deprecation = :notify

  # I18n configuration
  config.i18n.fallbacks = true
end
