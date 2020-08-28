# frozen_string_literal: true

# ## Schema Information
#
# Table name: `photos`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `uuid`             | `not null, primary key`
# **`alt`**         | `text`             |
# **`file_data`**   | `jsonb`            |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
FactoryBot.define do
  factory :photo do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/photos/sunset.jpg'), 'image/jpeg') }
    alt { Faker::Lorem.sentence }
  end
end
