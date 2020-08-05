# frozen_string_literal: true

# == Schema Information
#
# Table name: oauth_access_grants
#
#  id                :uuid             not null, primary key
#  expires_in        :integer          not null
#  redirect_uri      :text             not null
#  revoked_at        :datetime
#  scopes            :text             default(""), not null
#  token             :text             not null
#  created_at        :datetime         not null
#  application_id    :uuid             not null
#  resource_owner_id :uuid             not null
#
# Indexes
#
#  index_oauth_access_grants_on_application_id     (application_id)
#  index_oauth_access_grants_on_resource_owner_id  (resource_owner_id)
#  index_oauth_access_grants_on_token              (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (application_id => oauth_applications.id)
#  fk_rails_...  (resource_owner_id => users.id)
#
module Auth
  # Unified OAuth2/IndieAuth access grant.
  class AccessGrant < ApplicationRecord
    include Doorkeeper::Orm::ActiveRecord::Mixins::AccessGrant

    self.table_name = 'oauth_access_grants'

    belongs_to :user, foreign_key: :resource_owner_id, inverse_of: :access_grants
  end
end
