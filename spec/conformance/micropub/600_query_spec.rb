# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Micropub Server Implementation Report - Query', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:application) }
  let(:access_token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

  let(:headers) do
    {
      'Authorization' => "Bearer #{access_token.token}"
    }
  end

  before { get '/micropub', params: params, headers: headers }

  # https://micropub.rocks/server-tests/600?endpoint=501
  describe '600 - Configuration Query' do
    let(:params) { { q: 'config' } }

    it 'returns HTTP 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns a JSON object' do
      expect(JSON.parse(response.body)).to be_a(Hash)
    end
  end

  # https://micropub.rocks/server-tests/601?endpoint=501
  pending '601 - Syndication Endpoint Query'

  # https://micropub.rocks/server-tests/602?endpoint=501
  pending '602 - Source Query (All Properties)'

  # https://micropub.rocks/server-tests/603?endpoint=501
  pending '603 - Source Query (Specific Properties)'
end
