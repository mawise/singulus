# frozen_string_literal: true

module Auth
  # Unified OAuth2/IndieAuth access grant.
  class AccessGrant < ApplicationRecord
    include Doorkeeper::Orm::ActiveRecord::Mixins::AccessGrant

    self.table_name = 'oauth_access_grants'
  end
end
