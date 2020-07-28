# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    content { Faker::Lorem.paragraph_by_chars(number: 250) }
    published_at { Faker::Date.backward(days: 365) }
  end
end
