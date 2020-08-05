# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/', type: :request, host: :shortlinks do
  describe 'GET /' do
    it 'returns HTTP success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end

  context 'with nonexistent link' do
    describe 'GET /:id' do
      it 'returns HTTP not found' do
        get '/nonexistent-link'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'with existing link' do
    let(:shortlink) { FactoryBot.create(:shortlink) }

    describe 'GET /:id' do
      it 'redirects to the target URL of the link' do
        get "/#{shortlink.link}"
        expect(response).to redirect_to(shortlink.target_url)
      end
    end
  end
end
