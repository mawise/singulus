# frozen_string_literal: true

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
end
