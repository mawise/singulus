# frozen_string_literal: true

require 'rails_helper'

describe Entry, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it 'generates a unique short ID upon creation' do
    entry = FactoryBot.create(:note, author: user)
    expect(entry.short_uid).not_to be_nil
  end

  it 'generates a slug from the name upon creation if none is specified' do
    entry = FactoryBot.create(:note, name: 'My Post', author: user)
    expect(entry.slug).to eq('my-post')
  end

  it 'generates a slug from the short UID upon creation if no name is specified' do
    entry = FactoryBot.create(:note, author: user)
    expect(entry.slug).to eq(entry.short_uid)
  end
end
