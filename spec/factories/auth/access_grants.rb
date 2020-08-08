# frozen_string_literal: true

# ## Schema Information
#
# Table name: `oauth_access_grants`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `uuid`             | `not null, primary key`
# **`code_challenge`**         | `text`             |
# **`code_challenge_method`**  | `text`             |
# **`expires_in`**             | `integer`          | `not null`
# **`redirect_uri`**           | `text`             | `not null`
# **`revoked_at`**             | `datetime`         |
# **`scopes`**                 | `text`             | `default(""), not null`
# **`token`**                  | `text`             | `not null`
# **`created_at`**             | `datetime`         | `not null`
# **`application_id`**         | `uuid`             | `not null`
# **`resource_owner_id`**      | `uuid`             | `not null`
#
# ### Indexes
#
# * `index_oauth_access_grants_on_application_id`:
#     * **`application_id`**
# * `index_oauth_access_grants_on_resource_owner_id`:
#     * **`resource_owner_id`**
# * `index_oauth_access_grants_on_token` (_unique_):
#     * **`token`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`application_id => oauth_applications.id`**
# * `fk_rails_...`:
#     * **`resource_owner_id => users.id`**
#
FactoryBot.define do
  factory :oauth_access_grant, class: 'Auth::AccessGrant' do
    association :application, factory: :oauth_application
    association :resource_owner, factory: :user
    expires_in { 2.hours }
    scopes { %i[profile] }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
  end
end
