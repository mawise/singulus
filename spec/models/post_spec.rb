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
require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { FactoryBot.create(:user) }

  %i[article note like reply repost].each do |type|
    it "caches the post type for a #{type}" do
      post = FactoryBot.create(type)
      expect(post.type).to eq(type.to_s)
    end
  end

  it 'returns the post type for a post with photos' do
    post = FactoryBot.create(:post_with_photos)
    expect(post.type).to eq('photo')
  end

  it 'generates a unique short ID upon creation' do
    post = FactoryBot.create(:note, author: user)
    expect(post.short_uid).not_to be_nil
  end

  it 'generates a slug from the name upon creation if none is specified' do
    post = FactoryBot.create(:note, name: 'My Post', author: user)
    expect(post.slug).to eq('my-post')
  end

  it 'generates a slug from the short UID upon creation if no name is specified' do
    post = FactoryBot.create(:note, author: user)
    expect(post.slug).to eq(post.short_uid)
  end

  it 'converts category names to categories on create' do
    post = FactoryBot.create(:note, author: user, category_names: 'one, two, three')
    expect(post.categories).to eq(%w[one two three])
  end

  it 'converts category names to categories on update' do
    post = FactoryBot.create(:note, author: user, categories: %w[one two three])
    expect { post.update(category_names: 'four, five, six') }.to change(post, :categories).to eq(%w[four five six])
  end

  it 'returns categories as comma-separated category names' do
    post = FactoryBot.create(:note, author: user, categories: %w[one two three])
    expect(post.category_names).to eq('one, two, three')
  end
end
