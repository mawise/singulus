# frozen_string_literal: true

require 'rails_helper'

# See spec/conformance/micropub for Micropub server implementation tests
RSpec.describe '/micropub', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:application) }
  let(:access_token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
  let(:auth_header) { { 'Authorization': "Bearer #{access_token.token}" } }

  describe 'POST to /micropub with unsupported content type' do
    before do
      post '/micropub', headers: { 'Content-Type': 'text/plain' }.merge(auth_header)
    end

    it 'returns HTTP unsupported media type' do
      expect(response).to have_http_status(:unsupported_media_type)
    end

    it 'returns an invalid_request error message' do
      expect(JSON.parse(response.body)['error']).to eq('invalid_request')
    end
  end
end
