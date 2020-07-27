# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    content { Faker::Lorem.paragraph_by_chars(number: 250) }
  end
end
