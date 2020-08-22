# frozen_string_literal: true

Rails.application.configure do # rubocop:disable Metrics/BlockLength
  # General Rails configuration
  config.cache_classes = false
  config.consider_all_requests_local = true
  config.eager_load = false

  # Logging configuration
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Caching configuration
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # ActionMailer configuration
  config.action_mailer.default_url_options = { host: Rails.configuration.x.singulus.host }
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  if ENV['MAILTRAP_SMTP_USERNAME'] && ENV['MAILTRAP_SMTP_PASSWORD']
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      user_name: ENV['MAILTRAP_SMTP_USERNAME'],
      password: ENV['MAILTRAP_SMTP_PASSWORD'],
      address: 'smtp.mailtrap.io',
      domain: 'smtp.mailtrap.io',
      port: '2525',
      authentication: :cram_md5
    }
  end

  # ActiveSupport configuration
  config.active_support.deprecation = :log

  # ActiveRecord configuration
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true

  # File watcher configuration
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Uploads configuration
  config.x.uploads.url = "#{ENV.fetch('UPLOADS_URL')}/singulus-development/"

  # Additional configuration
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
  end
end
