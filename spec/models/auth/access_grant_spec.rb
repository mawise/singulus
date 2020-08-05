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
require 'rails_helper'

# RSpec.describe Auth::AccessGrant, type: :model do
# end
