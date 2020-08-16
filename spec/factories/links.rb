# frozen_string_literal: true

# ## Schema Information
#
# Table name: `links`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`id`**             | `uuid`             | `not null, primary key`
# **`expires_in`**     | `integer`          |
# **`name`**           | `text`             | `not null`
# **`resource_type`**  | `string`           |
# **`tags`**           | `text`             | `default([]), not null, is an Array`
# **`target_url`**     | `text`             | `not null`
# **`title`**          | `text`             |
# **`created_at`**     | `datetime`         | `not null`
# **`updated_at`**     | `datetime`         | `not null`
# **`resource_id`**    | `uuid`             |
#
# ### Indexes
#
# * `index_links_on_name` (_unique_):
#     * **`name`**
# * `index_links_on_resource_id_and_resource_type`:
#     * **`resource_id`**
#     * **`resource_type`**
# * `index_links_on_resource_type_and_resource_id`:
#     * **`resource_type`**
#     * **`resource_id`**
# * `index_links_on_tags` (_using_ gin):
#     * **`tags`**
# * `index_links_on_target_url`:
#     * **`target_url`**
#
FactoryBot.define do
  factory :link do
    target_url { Faker::Internet.url }
  end
end
