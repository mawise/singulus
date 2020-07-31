# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/micropub', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:application) }
  let(:access_token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
  let(:auth_header) { { 'Authorization': "Bearer #{access_token.token}" } }

  describe 'GET to /micropub with no authentication' do
    before do
      get '/micropub'
    end

    it 'returns HTTP unauthorized' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error message in the response body' do
      expect(JSON.parse(response.body)['error']).to eq('unauthorized')
    end
  end
end
