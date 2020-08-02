# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Micropub Server Implementation Report - Deletes', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:oauth_application) }
  let(:access_token) { FactoryBot.create(:oauth_access_token, application: application, resource_owner_id: user.id) }

  before { post '/micropub', params: params, headers: headers }

  context 'when form-encoded' do
    let(:headers) do
      {
        'Authorization' => "Bearer #{access_token.token}",
        'Content-Type' => 'x-www-form-urlencoded'
      }
    end

    # https://micropub.rocks/server-tests/500?endpoint=501
    pending '500 - Delete a post (form-encoded)'

    # https://micropub.rocks/server-tests/502?endpoint=501
    pending '502 - Undelete a post (form-encoded)'
  end

  context 'when JSON' do
    let(:headers) do
      {
        'Authorization' => "Bearer #{access_token.token}",
        'Content-Type' => 'application/json'
      }
    end

    # https://micropub.rocks/server-tests/501?endpoint=501
    pending '501 - Delete a post (JSON)'

    # https://micropub.rocks/server-tests/503?endpoint=501
    pending '503 - Undelete a post (JSON)'
  end
end
