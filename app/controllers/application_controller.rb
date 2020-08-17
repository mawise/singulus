# frozen_string_literal: true

# Base class for all other controllers.
class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_root_path
  end

  def append_info_to_payload(payload)
    super
    payload[:host] = request.host
    payload[:source_ip] = request.remote_ip
  end
end
