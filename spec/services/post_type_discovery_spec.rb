# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostTypeDiscovery, type: :service do
  %i[article note like reply repost].each do |type|
    it "returns #{type} for a #{type}" do
      post = FactoryBot.build(type)
      post.valid?
      expect(post.type).to eq(type.to_s)
    end
  end

  it 'returns photo for a post with photos' do
    post = FactoryBot.build(:post_with_photos)
    post.valid?
    expect(post.type).to eq('photo')
  end
end
