# frozen_string_literal: true

# Represents a unified IndieAuth/OAuth2 access token.
#
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
module Auth
  # Unified OAuth2/IndieAuth access token.
  class AccessToken < ApplicationRecord
    include Doorkeeper::Orm::ActiveRecord::Mixins::AccessToken

    self.table_name = 'oauth_access_tokens'

    belongs_to :user, foreign_key: :resource_owner_id, inverse_of: :access_grants

    def as_indieauth_json(_options = {})
      user.as_indieauth_json.merge(
        scope: scopes.to_a.join(' '),
        expires_in: expires_in_seconds,
        client_id: application.url,
        created_at: created_at.to_i
      )
    end
  end
end
