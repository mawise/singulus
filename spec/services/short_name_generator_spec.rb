# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortNameGenerator, type: :service do
  subject(:generator) { described_class.new }

  it 'generates a six character ID' do
    expect(generator.call.size).to eq(6)
  end
end
