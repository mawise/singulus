# frozen_string_literal: true

# ## Schema Information
#
# Table name: `photos`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `uuid`             | `not null, primary key`
# **`alt`**              | `text`             |
# **`attachable_rel`**   | `text`             |
# **`attachable_type`**  | `string`           |
# **`duration`**         | `interval`         |
# **`file_data`**        | `jsonb`            |
# **`metadata`**         | `hstore`           | `not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`attachable_id`**    | `uuid`             |
# **`post_id`**          | `uuid`             |
#
# ### Indexes
#
# * `attachable`:
#     * **`attachable_id`**
#     * **`attachable_type`**
#     * **`attachable_rel`**
# * `index_photos_on_attachable_type_and_attachable_id`:
#     * **`attachable_type`**
#     * **`attachable_id`**
# * `index_photos_on_metadata` (_using_ gin):
#     * **`metadata`**
# * `index_photos_on_post_id`:
#     * **`post_id`**
#
FactoryBot.define do
  factory :photo do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/photos/sunset.jpg'), 'image/jpeg') }
    alt { Faker::Lorem.sentence }
  end
end
