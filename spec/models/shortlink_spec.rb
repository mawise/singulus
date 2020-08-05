# frozen_string_literal: true

# == Schema Information
#
# Table name: shortlinks
#
#  id            :uuid             not null, primary key
#  expires_in    :integer
#  link          :text             not null
#  resource_type :string
#  tags          :text             default([]), not null, is an Array
#  target_url    :text             not null
#  title         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :uuid
#
# Indexes
#
#  index_shortlinks_on_link                           (link) UNIQUE
#  index_shortlinks_on_resource_id_and_resource_type  (resource_id,resource_type)
#  index_shortlinks_on_resource_type_and_resource_id  (resource_type,resource_id)
#  index_shortlinks_on_tags                           (tags) USING gin
#  index_shortlinks_on_target_url                     (target_url)
#
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
