# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Micropub Server Implementation Report - Authentication', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:oauth_application) }
  let(:access_token) { FactoryBot.create(:oauth_access_token, application: application, resource_owner_id: user.id) }

  before { post '/micropub', params: params, headers: headers }

  # https://micropub.rocks/server-tests/800?endpoint=501
  describe '800 - Accept access token in HTTP header' do
    let(:headers) do
      {
        'Authorization' => "Bearer #{access_token.token}",
        'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8'
      }
    end

    let(:params) do
      {
        h: 'entry',
        content: 'Testing accepting access token in HTTP Authorization header'
      }
    end

    it 'returns HTTP 202' do
      expect(response).to have_http_status(:accepted)
    end

    it 'returns a Location header' do
      expect(response.headers).to have_key('Location')
    end
  end

  # https://micropub.rocks/server-tests/801?endpoint=501
  describe '801 - Accept access token in POST body' do
    let(:headers) do
      {
        'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8'
      }
    end

    let(:params) do
      {
        access_token: access_token.token,
        h: 'entry',
        content: 'Testing accepting access token in HTTP Authorization header'
      }
    end

    it 'returns HTTP 202' do
      expect(response).to have_http_status(:accepted)
    end

    it 'returns a Location header' do
      expect(response.headers).to have_key('Location')
    end
  end

  # https://micropub.rocks/server-tests/802?endpoint=501
  pending '802 - Does not store access token property'

  # https://micropub.rocks/server-tests/803?endpoint=501
  describe '803 - Rejects unauthenticated requests' do
    let(:headers) do
      {
        'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8'
      }
    end

    let(:params) do
      {
        h: 'entry',
        content: 'Testing unauthenticated request. This should not create a post.'
      }
    end

    it 'returns HTTP 401' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error message in the response body' do
      expect(JSON.parse(response.body)).to eq({ 'error' => 'unauthorized' })
    end
  end

  # https://micropub.rocks/server-tests/804?endpoint=501
  pending '804 - Rejects unauthorized access tokens'
end
