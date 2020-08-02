# frozen_string_literal: true

FactoryBot.define do
  factory :photo do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/photos/sunset.jpg'), 'image/jpeg') }
    alt { Faker::Lorem.sentence }
  end
end
