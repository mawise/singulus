# frozen_string_literal: true

FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    application
    expires_in { 2.hours }
    scopes { %i[user:read] }
  end
end
