# frozen_string_literal: true

FactoryBot.define do
  factory :shortlink do
    target_url { Faker::Internet.url }
  end
end
