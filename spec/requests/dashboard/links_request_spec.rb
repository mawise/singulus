# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/dashboard/links', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET /dashboard/links' do
    it 'returns HTTP success' do
      get '/dashboard/links'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /dashboard/links' do
    let(:target_url) { Faker::Internet.url }
    let(:params) { { name: { target_url: target_url } } }

    it 'redirects to the new link' do
      post '/dashboard/links', params: params
      new_link = Link.find_by(target_url: target_url)
      expect(response).to redirect_to(dashboard_link_path(new_link))
    end
  end

  context 'with existing link' do
    let(:link) { FactoryBot.create(:link) }

    describe 'GET /dashboard/links/:id' do
      it 'returns HTTP success' do
        get "/dashboard/links/#{link.id}"
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PATCH /dashboard/links/:id' do
      let(:params) { { name: { alt: 'new alt text' } } }

      it 'redirects to the link' do
        patch "/dashboard/links/#{link.id}", params: params
        expect(response).to redirect_to(dashboard_link_path(link))
      end
    end

    describe 'DELETE /dashboard/links/:id' do
      it 'redirects to /links' do
        delete "/dashboard/links/#{link.id}"
        expect(response).to redirect_to(dashboard_links_path)
      end
    end
  end
end
