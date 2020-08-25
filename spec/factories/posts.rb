# frozen_string_literal: true

# ## Schema Information
#
# Table name: `posts`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `uuid`             | `not null, primary key`
# **`bookmark_of`**            | `jsonb`            |
# **`categories`**             | `text`             | `default([]), is an Array`
# **`content`**                | `text`             |
# **`content_html`**           | `text`             |
# **`in_reply_to`**            | `jsonb`            |
# **`like_of`**                | `jsonb`            |
# **`location`**               | `jsonb`            |
# **`meta_description`**       | `text`             |
# **`name`**                   | `text`             |
# **`og_description`**         | `text`             |
# **`og_image`**               | `text`             |
# **`og_locale`**              | `text`             |
# **`og_title`**               | `text`             |
# **`og_type`**                | `text`             |
# **`og_url`**                 | `text`             |
# **`properties`**             | `jsonb`            | `not null`
# **`published_at`**           | `datetime`         |
# **`repost_of`**              | `jsonb`            |
# **`rsvp`**                   | `integer`          |
# **`short_uid`**              | `text`             |
# **`slug`**                   | `text`             |
# **`summary`**                | `text`             |
# **`syndications`**           | `text`             | `is an Array`
# **`twitter_card`**           | `text`             |
# **`twitter_creator`**        | `text`             |
# **`twitter_description`**    | `text`             |
# **`twitter_image`**          | `text`             |
# **`twitter_image_alt`**      | `text`             |
# **`twitter_player`**         | `text`             |
# **`twitter_player_height`**  | `integer`          |
# **`twitter_player_stream`**  | `text`             |
# **`twitter_player_width`**   | `integer`          |
# **`twitter_site`**           | `text`             |
# **`twitter_title`**          | `text`             |
# **`type`**                   | `text`             |
# **`url`**                    | `text`             |
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
# **`author_id`**              | `uuid`             | `not null`
# **`featured_id`**            | `uuid`             |
# **`twitter_creator_id`**     | `text`             |
# **`twitter_site_id`**        | `text`             |
#
# ### Indexes
#
# * `index_posts_on_author_id`:
#     * **`author_id`**
# * `index_posts_on_bookmark_of` (_using_ gin):
#     * **`bookmark_of`**
# * `index_posts_on_categories` (_using_ gin):
#     * **`categories`**
# * `index_posts_on_featured_id`:
#     * **`featured_id`**
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
# * `fk_rails_...`:
#     * **`featured_id => photos.id`**
#
FactoryBot.define do
  factory :post do
    association :author, factory: :user

    trait :published do
      transient do
        timestamp { Faker::Date.between(from: 1.year.ago, to: Time.zone.today) }
      end

      created_at { timestamp }
      updated_at { timestamp }
      published_at { timestamp }
    end

    trait :categorized do
      categories { Array.new(rand(10)) { Faker::Hacker.adjective } }
    end

    trait :with_featured do
      association :featured, factory: :photo
    end

    factory :post_with_photos do
      transient do
        photos_count { 1 }
      end

      after(:build) do |post, evaluator|
        post.photos_attributes = Array.new(evaluator.photos_count) do
          {
            file: Rack::Test::UploadedFile.new(
              Dir.glob(Rails.root.join('spec/fixtures/photos/*.jpeg')).sample, 'image/jpeg'
            ),
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

    factory :bookmark do
      transient do
        timestamp { Faker::Time.between(from: 1.year.ago, to: Time.zone.today) }
      end

      created_at { timestamp }
      updated_at { timestamp }
      published_at { timestamp }
      bookmark_of do
        url = Faker::Internet.url
        email = Faker::Internet.email
        {
          name: Faker::Lorem.sentence,
          author: {
            name: Faker::Name.name,
            email: email,
            url: Faker::Internet.url,
            photo: "https://api.adorable.io/avatars/64/#{email}.png"
          },
          url: url,
          uid: url,
          accessed: timestamp.iso8601,
          published: Faker::Time.between(from: 2.years.ago, to: timestamp).iso8601
        }
      end
    end

    factory :like do
      transient do
        timestamp { Faker::Time.between(from: 1.year.ago, to: Time.zone.today) }
      end

      created_at { timestamp }
      updated_at { timestamp }
      published_at { timestamp }
      like_of do
        url = Faker::Internet.url
        email = Faker::Internet.email
        {
          name: Faker::Lorem.sentence,
          author: {
            name: Faker::Name.name,
            email: Faker::Internet.email,
            url: Faker::Internet.url,
            photo: "https://api.adorable.io/avatars/64/#{email}.png"
          },
          url: url,
          uid: url,
          accessed: timestamp.iso8601,
          published: Faker::Time.between(from: 2.years.ago, to: timestamp).iso8601
        }
      end
    end

    factory :note do
      content { Faker::Lorem.paragraph_by_chars(number: 250) }
    end

    factory :reply do
      transient do
        timestamp { Faker::Time.between(from: 1.year.ago, to: Time.zone.today) }
      end

      content { Faker::Lorem.paragraph_by_chars(number: 250) }
      created_at { timestamp }
      updated_at { timestamp }
      published_at { timestamp }
      in_reply_to do
        url = Faker::Internet.url
        email = Faker::Internet.email
        {
          name: Faker::Lorem.sentence,
          author: {
            name: Faker::Name.name,
            email: Faker::Internet.email,
            url: Faker::Internet.url,
            photo: "https://api.adorable.io/avatars/64/#{email}.png"
          },
          url: url,
          uid: url,
          accessed: timestamp.iso8601,
          content: Faker::Lorem.paragraph_by_chars(number: 250),
          published: Faker::Time.between(from: 2.years.ago, to: timestamp).iso8601
        }
      end
    end

    factory :repost do
      transient do
        timestamp { Faker::Time.between(from: 1.year.ago, to: Time.zone.today) }
      end

      created_at { timestamp }
      updated_at { timestamp }
      published_at { timestamp }
      repost_of do
        url = Faker::Internet.url
        email = Faker::Internet.email
        {
          name: Faker::Lorem.sentence,
          author: {
            name: Faker::Name.name,
            email: Faker::Internet.email,
            url: Faker::Internet.url,
            photo: "https://api.adorable.io/avatars/64/#{email}.png"
          },
          url: url,
          uid: url,
          accessed: timestamp.iso8601,
          published: Faker::Time.between(from: 2.years.ago, to: timestamp).iso8601
        }
      end
    end
  end
end
