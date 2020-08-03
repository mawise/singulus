# frozen_string_literal: true

module Auth
  # Unified OAuth2/IndieAuth access token.
  class AccessToken < ApplicationRecord
    include Doorkeeper::Orm::ActiveRecord::Mixins::AccessToken

    self.table_name = 'oauth_access_tokens'

    belongs_to :user, foreign_key: :resource_owner_id, inverse_of: :access_grants

    def as_indieauth_json(_options = {})
      {
        me: user.canonical_profile_url,
        scope: scopes.to_a.join(' '),
        expires_in: expires_in_seconds,
        client_id: application.url,
        created_at: created_at.to_i
      }
    end
  end
end
