# frozen_string_literal: true

FactoryBot.define do
  factory :entry do
    trait :published do
      published_at { Faker::Date.backwards(1.year) }
    end
  end
end
