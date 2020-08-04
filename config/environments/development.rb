# frozen_string_literal: true

Rails.application.configure do # rubocop:disable Metrics/BlockLength
  # General Rails configuration
  config.cache_classes = false
  config.consider_all_requests_local = true
  config.eager_load = false

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

  # Assets configuration
  config.assets.debug = true
  config.assets.quiet = true
  config.assets.url = "#{ENV.fetch('ASSETS_URL')}/singulus-development/"

  # ActionMailer configuration
  config.action_mailer.default_url_options = { host: 'localhost', port: ENV.fetch('PORT', 5000) }
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  # ActiveSupport configuration
  config.active_support.deprecation = :log

  # ActiveRecord configuration
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true

  # File watcher configuration
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

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
