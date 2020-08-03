# frozen_string_literal: true

module Auth
  # Unified OAuth2/IndieAuth access grant.
  class AccessGrant < ApplicationRecord
    include Doorkeeper::Orm::ActiveRecord::Mixins::AccessGrant

    self.table_name = 'oauth_access_grants'

    belongs_to :user, foreign_key: :resource_owner_id, inverse_of: :access_grants
  end
end
