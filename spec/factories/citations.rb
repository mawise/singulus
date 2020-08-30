# frozen_string_literal: true

# ## Schema Information
#
# Table name: `citations`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `uuid`             | `not null, primary key`
# **`accessed_at`**   | `datetime`         |
# **`author`**        | `jsonb`            |
# **`content`**       | `text`             |
# **`name`**          | `text`             |
# **`publication`**   | `text`             |
# **`published_at`**  | `datetime`         |
# **`uid`**           | `text`             | `not null`
# **`urls`**          | `text`             | `is an Array`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_citations_on_name`:
#     * **`name`**
# * `index_citations_on_publication`:
#     * **`publication`**
# * `index_citations_on_uid` (_unique_):
#     * **`uid`**
# * `index_citations_on_urls` (_using_ gin):
#     * **`urls`**
#
FactoryBot.define do
  factory :citation do
    transient do
      timestamp { Faker::Time.between(from: 1.year.ago, to: Time.zone.today) }
      url_count { 1 }
    end

    author do
      email = Faker::Internet.email
      {
        name: Faker::Name.name,
        email: email,
        url: Faker::Internet.url,
        photo: "https://api.adorable.io/avatars/64/#{email}.png"
      }
    end

    content { Faker::Lorem.paragraph }
    name { Faker::Lorem.sentence }
    uid { urls.first }
    urls { Array.new(url_count) { Faker::Internet.url } }
    accessed_at { Time.zone.now }
    published_at { Faker::Time.between(from: 2.years.ago, to: timestamp) }
  end
end
