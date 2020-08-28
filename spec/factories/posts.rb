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
# **`published_at`**           | `datetime`         |
# **`rsvp`**                   | `integer`          |
# **`short_uid`**              | `text`             |
# **`slug`**                   | `text`             |
# **`summary`**                | `text`             |
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
# **`twitter_creator_id`**     | `text`             |
# **`twitter_site_id`**        | `text`             |
#
# ### Indexes
#
# * `index_posts_on_author_id`:
#     * **`author_id`**
# * `index_posts_on_categories` (_using_ gin):
#     * **`categories`**
# * `index_posts_on_location` (_using_ gin):
#     * **`location`**
# * `index_posts_on_published_at`:
#     * **`published_at`**
# * `index_posts_on_rsvp`:
#     * **`rsvp`**
# * `index_posts_on_short_uid` (_unique_):
#     * **`short_uid`**
# * `index_posts_on_slug` (_unique_):
#     * **`slug`**
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

    trait :with_featured_photos do
      transient do
        featured_photo_count { 1 }
      end

      featured_photo_attachments_attributes do
        Array.new(featured_photo_count) do
          {
            rel: 'featured',
            attachable_type: 'Photo',
            attachable_attributes: {
              file: File.new(Dir[Rails.root.join('spec/fixtures/photos/*')].sample),
              alt: Faker::Lorem.sentence
            }
          }
        end
      end
    end

    factory :photo_post do
      transient do
        photo_count { 1 }
      end

      photo_attachments_attributes do
        Array.new(photo_count) do
          {
            rel: 'photo',
            attachable_type: 'Photo',
            attachable_attributes: {
              file: File.new(Dir[Rails.root.join('spec/fixtures/photos/*')].sample),
              alt: Faker::Lorem.sentence
            }
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
