# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/dashboard/shortlinks', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET /dashboard/shortlinks' do
    it 'returns HTTP success' do
      get '/dashboard/shortlinks'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /dashboard/shortlinks' do
    let(:target_url) { Faker::Internet.url }
    let(:params) { { shortlink: { target_url: target_url } } }

    it 'redirects to the new shortlink' do
      post '/dashboard/shortlinks', params: params
      new_shortlink = Shortlink.find_by(target_url: target_url)
      expect(response).to redirect_to(dashboard_shortlink_path(new_shortlink))
    end
  end

  context 'with existing shortlink' do
    let(:shortlink) { FactoryBot.create(:shortlink) }

    describe 'GET /dashboard/shortlinks/:id' do
      it 'returns HTTP success' do
        get "/dashboard/shortlinks/#{shortlink.id}"
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PATCH /dashboard/shortlinks/:id' do
      let(:params) { { shortlink: { alt: 'new alt text' } } }

      it 'redirects to the shortlink' do
        patch "/dashboard/shortlinks/#{shortlink.id}", params: params
        expect(response).to redirect_to(dashboard_shortlink_path(shortlink))
      end
    end

    describe 'DELETE /dashboard/shortlinks/:id' do
      it 'redirects to /shortlinks' do
        delete "/dashboard/shortlinks/#{shortlink.id}"
        expect(response).to redirect_to(dashboard_shortlinks_path)
      end
    end
  end
end
