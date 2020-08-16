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
require 'rails_helper'
