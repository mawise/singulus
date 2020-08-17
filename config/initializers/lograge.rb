require 'lograge/sql/extension'

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new
  config.lograge.base_controller_class = ['ActionController::API', 'ActionController::Base']
  config.lograge.ignore_actions = ['HealthController#index']
  config.lograge.custom_options = lambda do |event|
    event.payload.merge(
      headers: event.payload[:headers].to_h.filter { |k, _| k.start_with?('HTTP') }
    )
  end
end
