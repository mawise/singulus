# frozen_string_literal: true

# Represents a unified IndieAuth/OAuth2 client application.
#
# ## Schema Information
#
# Table name: `oauth_applications`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `uuid`             | `not null, primary key`
# **`confidential`**  | `boolean`          | `default(TRUE), not null`
# **`name`**          | `text`             | `not null`
# **`redirect_uri`**  | `text`             |
# **`scopes`**        | `text`             | `default(""), not null`
# **`secret`**        | `text`             | `not null`
# **`uid`**           | `text`             | `not null`
# **`url`**           | `text`             |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_oauth_applications_on_uid` (_unique_):
#     * **`uid`**
# * `index_oauth_applications_on_url` (_unique_):
#     * **`url`**
#
module Auth
  # Unified OAuth2/IndieAuth application.
  class Application < ApplicationRecord
    include Doorkeeper::Orm::ActiveRecord::Mixins::Application

    self.table_name = 'oauth_applications'

    validates :url, uniqueness: { case_sensitive: true }
  end
end
