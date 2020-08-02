# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_access_token, class: 'Auth::AccessToken' do
    association :application, factory: :oauth_application
    expires_in { 2.hours }
    scopes { %i[user:read] }
  end
end
