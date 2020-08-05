# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shortlink, type: :model do
  it 'generates a unique link upon creation when none is present' do
    shortlink = FactoryBot.create(:shortlink)
    expect(shortlink.link).not_to be_nil
  end

  it 'uses the provided link when present' do
    shortlink = FactoryBot.create(:shortlink, link: 'mylink')
    expect(shortlink.link).to eq('mylink')
  end

  it 'converts tag names to tags on create' do
    shortlink = FactoryBot.create(:shortlink, tag_names: 'one, two, three')
    expect(shortlink.tags).to eq(%w[one two three])
  end

  it 'converts tag names to tags on update' do
    shortlink = FactoryBot.create(:shortlink, tags: %w[one two three])
    expect { shortlink.update(tag_names: 'four, five, six') }.to change(shortlink, :tags).to eq(%w[four five six])
  end

  it 'returns tags as comma-separated tag names' do
    shortlink = FactoryBot.create(:shortlink, tags: %w[one two three])
    expect(shortlink.tag_names).to eq('one, two, three')
  end
end
