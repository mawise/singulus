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
# **`categories`**             | `text`             | `default([]), is an Array`
# **`content`**                | `text`             |
# **`content_html`**           | `text`             |
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
# * `index_posts_on_categories` (_using_ gin):
#     * **`categories`**
# * `index_posts_on_featured_id`:
#     * **`featured_id`**
# * `index_posts_on_location` (_using_ gin):
#     * **`location`**
# * `index_posts_on_properties` (_using_ gin):
#     * **`properties`**
# * `index_posts_on_published_at`:
#     * **`published_at`**
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

    factory :photo_post do
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

    factory :note_post do
      content { Faker::Lorem.paragraph_by_chars(number: 250) }
    end

    factory :article_post do
      content { Faker::Lorem.paragraphs.join("\n\n") }
      summary { Faker::Lorem.paragraph }
      name { Faker::Lorem.sentence }
    end

    factory :bookmark_post do
      transient do
        citation_count { 1 }
        timestamp { Faker::Time.between(from: 1.year.ago, to: Time.zone.now) }
      end

      created_at { timestamp }
      updated_at { timestamp }
      published_at { timestamp }

      bookmarks_attributes do
        Array.new(citation_count) do
          attributes_for(:citation, :bookmark, timestamp: timestamp)
        end
      end
    end

    factory :like_post do
      transient do
        citation_count { 1 }
        timestamp { Faker::Time.between(from: 1.year.ago, to: Time.zone.now) }
      end

      created_at { timestamp }
      updated_at { timestamp }
      published_at { timestamp }

      likes_attributes do
        Array.new(citation_count) do
          attributes_for(:citation, :like, timestamp: timestamp)
        end
      end
    end

    factory :reply_post do
      transient do
        citation_count { 1 }
        timestamp { Faker::Time.between(from: 1.year.ago, to: Time.zone.now) }
      end

      created_at { timestamp }
      updated_at { timestamp }
      published_at { timestamp }

      recipients_attributes do
        Array.new(citation_count) do
          attributes_for(:citation, :reply, timestamp: timestamp)
        end
      end
    end

    factory :repost_post do
      transient do
        citation_count { 1 }
        timestamp { Faker::Time.between(from: 1.year.ago, to: Time.zone.now) }
      end

      created_at { timestamp }
      updated_at { timestamp }
      published_at { timestamp }

      reposts_attributes do
        Array.new(citation_count) do
          attributes_for(:citation, :repost, timestamp: timestamp)
        end
      end
    end
  end
end
