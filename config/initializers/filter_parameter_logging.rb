# frozen_string_literal: true

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  access_token
  client_secret
  code
  password
  password_confirmation
  refresh_token
]
