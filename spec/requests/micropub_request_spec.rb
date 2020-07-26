# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Micropubs', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:application) }
  let(:access_token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

  describe 'GET /micropub' do
    context 'with q=config' do
      it 'succeeds' do
        get '/micropub', params: { q: 'config' }, headers: { 'Authorization' => "Bearer #{access_token.token}" }
        expect(response).to have_http_status(:success)
      end
    end
  end
end
