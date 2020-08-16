# frozen_string_literal: true

# Represents a user who can log in to Singulus.
#
# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                       | Type               | Attributes
# -------------------------- | ------------------ | ---------------------------
# **`id`**                   | `uuid`             | `not null, primary key`
# **`current_sign_in_at`**   | `datetime`         |
# **`current_sign_in_ip`**   | `inet`             |
# **`email`**                | `string`           | `default(""), not null`
# **`encrypted_password`**   | `string`           | `default(""), not null`
# **`failed_attempts`**      | `integer`          | `default(0), not null`
# **`last_sign_in_at`**      | `datetime`         |
# **`last_sign_in_ip`**      | `inet`             |
# **`locked_at`**            | `datetime`         |
# **`name`**                 | `string`           | `default(""), not null`
# **`photo_url`**            | `text`             |
# **`profile_url`**          | `text`             |
# **`remember_created_at`**  | `datetime`         |
# **`sign_in_count`**        | `integer`          | `default(0), not null`
# **`unlock_token`**         | `string`           |
# **`created_at`**           | `datetime`         | `not null`
# **`updated_at`**           | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_users_on_email` (_unique_):
#     * **`email`**
# * `index_users_on_profile_url`:
#     * **`profile_url`**
# * `index_users_on_unlock_token` (_unique_):
#     * **`unlock_token`**
#
class User < ApplicationRecord
  devise :database_authenticatable, :lockable,
         :rememberable, :trackable, :validatable

  has_many :access_grants,
           inverse_of: :user,
           class_name: 'Auth::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :access_tokens,
           inverse_of: :user,
           class_name: 'Auth::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :posts, as: :author, inverse_of: :author, dependent: :destroy

  def to_indieauth_json
    as_indieauth_json.to_json
  end

  def as_indieauth_json
    {
      me: profile_url,
      profile: {
        type: 'card',
        name: name,
        url: profile_url,
        photo: photo_url
      }
    }
  end
end
