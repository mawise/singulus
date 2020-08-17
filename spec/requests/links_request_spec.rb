# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/', type: :request, host: :links do
  describe 'GET /' do
    it 'redirects to the main site' do
      get '/'
      expect(response).to redirect_to(Rails.configuration.x.site.url)
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
    let(:link) { FactoryBot.create(:link) }

    describe 'GET /:id' do
      it 'redirects to the target URL of the link' do
        get "/#{link.name}"
        expect(response).to redirect_to(link.target_url)
      end
    end
  end
end
