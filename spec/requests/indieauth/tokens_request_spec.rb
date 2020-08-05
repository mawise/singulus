# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/indieauth/token', type: :request do
  describe 'GET /indieauth/token' do
    context 'with a valid token' do
      let(:user) { FactoryBot.create(:user) }
      let(:application) { FactoryBot.create(:oauth_application) }
      let(:access_token) do
        FactoryBot.create(:oauth_access_token, application: application, resource_owner_id: user.id)
      end
      let(:auth_header) { { 'Authorization': "Bearer #{access_token.token}" } }

      it 'returns HTTP success' do
        get '/indieauth/token', headers: auth_header
        expect(response).to have_http_status(:success)
      end
    end

    context 'with an invalid token' do
      it 'returns HTTP unauthorized' do
        get '/indieauth/token', headers: { 'Authorization': 'Bearer invalid-token' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
