# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id           :uuid             not null, primary key
#  categories   :text             default([]), is an Array
#  content      :text
#  name         :text
#  properties   :jsonb            not null
#  published_at :datetime
#  short_uid    :text
#  slug         :text
#  summary      :text
#  url          :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :uuid             not null
#
# Indexes
#
#  index_posts_on_author_id     (author_id)
#  index_posts_on_categories    (categories) USING gin
#  index_posts_on_properties    (properties) USING gin
#  index_posts_on_published_at  (published_at)
#  index_posts_on_short_uid     (short_uid) UNIQUE
#  index_posts_on_slug          (slug) UNIQUE
#  index_posts_on_url           (url)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
require 'rails_helper'

describe Post, type: :model do
  let(:user) { FactoryBot.create(:user) }

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
