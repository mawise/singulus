# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Micropub Server Implementation Report - Creating Posts (JSON)', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:application) }
  let(:access_token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

  let(:headers) do
    {
      'Authorization' => "Bearer #{access_token.token}",
      'Content-Type' => 'application/json'
    }
  end

  before { post '/micropub', params: params, headers: headers }

  # https://micropub.rocks/server-tests/200?endpoint=501
  pending '200 - Create an h-entry post (JSON)'

  # https://micropub.rocks/server-tests/201?endpoint=501
  pending '201 - Create an h-entry post with multiple categories (JSON)'

  # https://micropub.rocks/server-tests/202?endpoint=501
  pending '202 - Create an h-entry with HTML content (JSON)'

  # https://micropub.rocks/server-tests/203?endpoint=501
  pending '203 - Create an h-entry with a photo referenced by URL (JSON)'

  # https://micropub.rocks/server-tests/204?endpoint=501
  pending '204 - Create an h-entry post with a nested object (JSON)'

  # https://micropub.rocks/server-tests/205?endpoint=501
  pending '205 - Create an h-entry post with a photo with alt text (JSON)'

  # https://micropub.rocks/server-tests/206?endpoint=501
  pending '206 - Create an h-entry with multiple photos referenced by URL (JSON)'
end
