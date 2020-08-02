# frozen_string_literal: true

Rails.application.configure do
  # General Rails configuration
  config.cache_classes = false
  config.cache_store = :null_store
  config.consider_all_requests_local = true
  config.eager_load = false

  # Public file server configuration
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Assets configuration
  config.assets.url = 'http://localhost:9000/singulus-test/'

  # ActionController configuration
  config.action_controller.allow_forgery_protection = false
  config.action_controller.perform_caching = false

  # ActionDispatch configuration
  config.action_dispatch.show_exceptions = false

  # ActionMailer configuration
  config.action_mailer.delivery_method = :test
  config.action_mailer.perform_caching = false

  # ActionView configuration
  config.action_view.cache_template_loading = true  

  # ActiveSupport configuration
  config.active_support.deprecation = :stderr

  # rack-attack configuration
  Rack::Attack.enabled = false
end
