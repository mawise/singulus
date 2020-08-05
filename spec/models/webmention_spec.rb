# frozen_string_literal: true

# ## Schema Information
#
# Table name: `webmentions`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `uuid`             | `not null, primary key`
# **`approved_at`**        | `datetime`         |
# **`deleted_at`**         | `datetime`         |
# **`short_uid`**          | `text`             | `not null`
# **`source_properties`**  | `jsonb`            | `not null`
# **`source_url`**         | `text`             | `not null`
# **`target_url`**         | `text`             | `not null`
# **`verified_at`**        | `datetime`         |
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`source_id`**          | `uuid`             |
# **`target_id`**          | `uuid`             |
#
# ### Indexes
#
# * `index_webmentions_on_source_id`:
#     * **`source_id`**
# * `index_webmentions_on_source_id_and_target_id` (_unique_):
#     * **`source_id`**
#     * **`target_id`**
# * `index_webmentions_on_source_properties` (_using_ gin):
#     * **`source_properties`**
# * `index_webmentions_on_source_url_and_target_id` (_unique_):
#     * **`source_url`**
#     * **`target_id`**
# * `index_webmentions_on_source_url_and_target_url` (_unique_):
#     * **`source_url`**
#     * **`target_url`**
# * `index_webmentions_on_target_id`:
#     * **`target_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`source_id => posts.id`**
# * `fk_rails_...`:
#     * **`target_id => posts.id`**
#
require 'rails_helper'

RSpec.describe Webmention, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post, author: user) }

  it 'generates a unique short ID upon creation' do
    webmention = FactoryBot.create(:webmention, source_url: Faker::Internet.url, target_url: post.permalink_url)
    expect(webmention.short_uid).not_to be_nil
  end

  context 'when source URL and target URL are the same' do
    subject(:webmention) { described_class.new(source_url: url, target_url: url) }

    let(:url) { Faker::Internet.url }

    it 'adds an error message' do
      webmention.valid?
      expect(webmention.errors[:source_url_and_target_url]).to include("can't be the same")
    end

    it 'is invalid' do
      expect(webmention).not_to be_valid
    end
  end

  context 'when the target URL is for a post that does not exist' do
    subject(:webmention) { described_class.new(source_url: source_url, target_url: target_url) }

    let(:source_url) { Faker::Internet.url }
    let(:target_url) { "#{Rails.configuration.x.site.url}/notes/abc123" }

    it 'adds an error message' do
      webmention.valid?
      expect(webmention.errors[:target_url]).to include('does not exist')
    end

    it 'is invalid' do
      expect(webmention).not_to be_valid
    end
  end

  context 'when the target URL is for a post that exists' do
    subject(:webmention) { described_class.new(source_url: source_url, target_url: target_url) }

    let(:source_url) { Faker::Internet.url }
    let(:target_url) { post.permalink_url }

    it 'is valid' do
      expect(webmention).to be_valid
    end
  end
end
