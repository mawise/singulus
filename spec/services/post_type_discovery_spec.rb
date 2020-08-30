# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostTypeDiscovery, type: :service do
  subject(:post_type_discovery) { described_class.new }

  %i[article bookmark note like photo reply repost].each do |type|
    it "returns #{type} for a #{type}" do
      post = FactoryBot.build(:"#{type}_post")
      expect(post_type_discovery.call(post)).to eq(type.to_s)
    end
  end
end
