# frozen_string_literal: true

# ## Schema Information
#
# Table name: `oauth_access_tokens`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`id`**                      | `uuid`             | `not null, primary key`
# **`expires_in`**              | `integer`          |
# **`previous_refresh_token`**  | `text`             | `default(""), not null`
# **`refresh_token`**           | `text`             |
# **`revoked_at`**              | `datetime`         |
# **`scopes`**                  | `text`             |
# **`token`**                   | `text`             | `not null`
# **`created_at`**              | `datetime`         | `not null`
# **`application_id`**          | `uuid`             | `not null`
# **`resource_owner_id`**       | `uuid`             |
#
# ### Indexes
#
# * `index_oauth_access_tokens_on_application_id`:
#     * **`application_id`**
# * `index_oauth_access_tokens_on_refresh_token` (_unique_):
#     * **`refresh_token`**
# * `index_oauth_access_tokens_on_resource_owner_id`:
#     * **`resource_owner_id`**
# * `index_oauth_access_tokens_on_token` (_unique_):
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
  factory :oauth_access_token, class: 'Auth::AccessToken' do
    resource_owner factory: :user
    application factory: :oauth_application
    expires_in { 2.hours }
    scopes { %i[profile] }
  end
end
