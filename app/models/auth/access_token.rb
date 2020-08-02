# frozen_string_literal: true

module Auth
  # Unified OAuth2/IndieAuth access token.
  class AccessToken < ApplicationRecord
    include Doorkeeper::Orm::ActiveRecord::Mixins::AccessToken

    self.table_name = 'oauth_access_tokens'
  end
end
