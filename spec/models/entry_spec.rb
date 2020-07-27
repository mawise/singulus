# frozen_string_literal: true

require 'rails_helper'

describe Entry, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it 'generates a unique short ID upon creation' do
    entry = FactoryBot.create(:note, author: user)
    expect(entry.short_uid).not_to be_nil
  end
end
