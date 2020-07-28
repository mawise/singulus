# frozen_string_literal: true

FactoryBot.define do
  factory :entry do
    trait :published do
      published_at { Faker::Date.backward(days: 365) }
    end

    factory :article do
      content { Faker::Lorem.paragraphs.join("\n\n") }
      summary { Faker::Lorem.paragraph }
      name { Faker::Lorem.sentence }
    end

    factory :note do
      content { Faker::Lorem.paragraph_by_chars(number: 250) }
    end
  end
end
