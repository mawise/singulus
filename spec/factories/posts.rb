# frozen_string_literal: true

# ## Schema Information
#
# Table name: `posts`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `uuid`             | `not null, primary key`
# **`bookmark_of`**   | `jsonb`            |
# **`categories`**    | `text`             | `default([]), is an Array`
# **`content`**       | `text`             |
# **`content_html`**  | `text`             |
# **`featured`**      | `text`             |
# **`in_reply_to`**   | `jsonb`            |
# **`like_of`**       | `jsonb`            |
# **`location`**      | `jsonb`            |
# **`name`**          | `text`             |
# **`properties`**    | `jsonb`            | `not null`
# **`published_at`**  | `datetime`         |
# **`repost_of`**     | `jsonb`            |
# **`rsvp`**          | `integer`          |
# **`short_uid`**     | `text`             |
# **`slug`**          | `text`             |
# **`summary`**       | `text`             |
# **`syndications`**  | `text`             | `is an Array`
# **`type`**          | `text`             |
# **`url`**           | `text`             |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`author_id`**     | `uuid`             | `not null`
#
# ### Indexes
#
# * `index_posts_on_author_id`:
#     * **`author_id`**
# * `index_posts_on_bookmark_of` (_using_ gin):
#     * **`bookmark_of`**
# * `index_posts_on_categories` (_using_ gin):
#     * **`categories`**
# * `index_posts_on_in_reply_to` (_using_ gin):
#     * **`in_reply_to`**
# * `index_posts_on_like_of` (_using_ gin):
#     * **`like_of`**
# * `index_posts_on_location` (_using_ gin):
#     * **`location`**
# * `index_posts_on_properties` (_using_ gin):
#     * **`properties`**
# * `index_posts_on_published_at`:
#     * **`published_at`**
# * `index_posts_on_repost_of` (_using_ gin):
#     * **`repost_of`**
# * `index_posts_on_rsvp`:
#     * **`rsvp`**
# * `index_posts_on_short_uid` (_unique_):
#     * **`short_uid`**
# * `index_posts_on_slug` (_unique_):
#     * **`slug`**
# * `index_posts_on_syndications` (_using_ gin):
#     * **`syndications`**
# * `index_posts_on_type`:
#     * **`type`**
# * `index_posts_on_url`:
#     * **`url`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`author_id => users.id`**
#
FactoryBot.define do
  factory :post do
    association :author, factory: :user

    trait :published do
      published_at { Faker::Date.backward(days: 365) }
    end

    factory :post_with_photos do
      transient do
        photos_count { 1 }
      end

      after(:build) do |post, evaluator|
        post.photos_attributes = Array.new(evaluator.photos_count) do
          {
            file: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/photos/sunset.jpg'), 'image/jpeg'),
            alt: Faker::Lorem.sentence
          }
        end
      end
    end

    factory :article do
      content { Faker::Lorem.paragraphs.join("\n\n") }
      summary { Faker::Lorem.paragraph }
      name { Faker::Lorem.sentence }
    end

    factory :like do
      like_of do
        url = Faker::Internet.url
        {
          name: Faker::Lorem.sentence,
          author: {
            name: Faker::Name.name,
            email: Faker::Internet.email,
            url: Faker::Internet.url,
            photo: 'https://via.placeholder.com/150'
          },
          url: url,
          uid: url,
          accessed: Time.now.utc.iso8601,
          content: Faker::Lorem.paragraph_by_chars(number: 250),
          publishe: Faker::Date.backward(days: 30)
        }
      end
    end

    factory :note do
      content { Faker::Lorem.paragraph_by_chars(number: 250) }
    end

    factory :reply do
      content { Faker::Lorem.paragraph }
      in_reply_to do
        url = Faker::Internet.url
        {
          name: Faker::Lorem.sentence,
          author: {
            name: Faker::Name.name,
            email: Faker::Internet.email,
            url: Faker::Internet.url,
            photo: 'https://via.placeholder.com/150'
          },
          url: url,
          uid: url,
          accessed: Time.now.utc.iso8601,
          content: Faker::Lorem.paragraph_by_chars(number: 250),
          publishe: Faker::Date.backward(days: 30)
        }
      end
    end

    factory :repost do
      repost_of do
        url = Faker::Internet.url
        {
          name: Faker::Lorem.sentence,
          author: {
            name: Faker::Name.name,
            email: Faker::Internet.email,
            url: Faker::Internet.url,
            photo: 'https://via.placeholder.com/150'
          },
          url: url,
          uid: url,
          accessed: Time.now.utc.iso8601,
          content: Faker::Lorem.paragraph_by_chars(number: 250),
          publishe: Faker::Date.backward(days: 30)
        }
      end
    end
  end
end
