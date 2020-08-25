# frozen_string_literal: true

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
# **`profile_url`**          | `text`             |
# **`remember_created_at`**  | `datetime`         |
# **`sign_in_count`**        | `integer`          | `default(0), not null`
# **`twitter_username`**     | `text`             |
# **`unlock_token`**         | `string`           |
# **`created_at`**           | `datetime`         | `not null`
# **`updated_at`**           | `datetime`         | `not null`
# **`photo_id`**             | `uuid`             |
# **`twitter_user_id`**      | `text`             |
#
# ### Indexes
#
# * `index_users_on_email` (_unique_):
#     * **`email`**
# * `index_users_on_photo_id`:
#     * **`photo_id`**
# * `index_users_on_profile_url`:
#     * **`profile_url`**
# * `index_users_on_unlock_token` (_unique_):
#     * **`unlock_token`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`photo_id => photos.id`**
#
require 'rails_helper'
