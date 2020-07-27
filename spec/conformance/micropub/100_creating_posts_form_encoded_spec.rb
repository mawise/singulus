# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Micropub Server Implementation Report - Creating Posts (Form-Encoded)', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:application) }
  let(:access_token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

  let(:headers) do
    {
      'Authorization' => "Bearer #{access_token.token}",
      'Content-Type' => 'x-www-form-urlencoded'
    }
  end

  before { post '/micropub', params: params, headers: headers }

  # https://micropub.rocks/server-tests/100?endpoint=501
  pending '100 - Create an h-entry post (form-encoded)'

  # https://micropub.rocks/server-tests/101?endpoint=501
  pending '101 - Create an h-entry post with multiple categories (form-encoded)'

  # https://micropub.rocks/server-tests/104?endpoint=501
  pending '104 - Create an h-entry with a photo referenced by URL (form-encoded)'

  # https://micropub.rocks/server-tests/107?endpoint=501
  pending '107 - Create an h-entry post with one category (form-encoded)'
end
