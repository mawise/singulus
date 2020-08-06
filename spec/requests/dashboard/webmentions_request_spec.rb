# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/dashboard/webmentions', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET /dashboard/webmentions' do
    it 'returns HTTP success' do
      get '/dashboard/webmentions'
      expect(response).to have_http_status(:success)
    end
  end

  context 'with existing webmention' do
    let(:target_post) { FactoryBot.create(:post, author: user) }
    let(:target_url) { target_post.permalink_url }
    let(:webmention) do
      FactoryBot.create(:webmention, source_url: Faker::Internet.url, target_url: target_url)
    end

    describe 'GET /dashboard/webmentions/:id' do
      it 'returns HTTP success' do
        get "/dashboard/webmentions/#{webmention.id}"
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PUT /dashboard/webmentions/:id/approve' do
      before { put "/dashboard/webmentions/#{webmention.id}/approve" }

      it 'redirects to the webmention' do
        expect(response).to redirect_to(dashboard_webmention_path(webmention))
      end

      it 'sets the status of the webmention to approved' do
        expect(webmention.reload.status).to eq('approved')
      end
    end

    describe 'PUT /dashboard/webmentions/:id/deny' do
      before { put "/dashboard/webmentions/#{webmention.id}/deny" }

      it 'redirects to the webmention' do
        expect(response).to redirect_to(dashboard_webmention_path(webmention))
      end

      it 'sets the status of the webmention to deny' do
        expect(webmention.reload.status).to eq('denied')
      end
    end

    describe 'DELETE /dashboard/webmentions/:id' do
      it 'redirects to /webmentions' do
        delete "/dashboard/webmentions/#{webmention.id}"
        expect(response).to redirect_to(dashboard_webmentions_path)
      end
    end
  end
end
