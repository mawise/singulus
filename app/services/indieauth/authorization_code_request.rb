# frozen_string_literal: true

require 'doorkeeper/oauth/client'
require 'doorkeeper/oauth/client/credentials'
require 'doorkeeper/request/authorization_code'

module IndieAuth
  # Exstension to Doorkeeper::Request::Authorization to support IndieAuth.
  class AuthorizationCodeRequest < Doorkeeper::Request::AuthorizationCode
    def request
      @request ||= Doorkeeper::OAuth::AuthorizationCodeRequest.new(
        Doorkeeper.config,
        grant,
        client,
        parameters
      )
    end

    def application
      @application ||= Auth::Application.find_by(url: parameters[:client_id])
    end

    def client
      @client ||= Doorkeeper::OAuth::Client.new(application)
    end

    private

    def grant
      raise Errors::MissingRequiredParameter, :code if parameters[:code].blank?

      Auth::AccessGrant.by_token(parameters[:code])
    end
  end
end
