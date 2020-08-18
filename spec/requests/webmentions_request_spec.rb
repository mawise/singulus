# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/webmentions', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:target_post) { FactoryBot.create(:post, author: user) }
  let(:target_url) { target_post.permalink_url }

  describe 'POST /webmentions' do
    context 'with valid webmention' do
      subject(:create_webmention) { post '/webmentions', params: { source: source_url, target: target_url } }

      let(:source_url) { Faker::Internet.url }
      let(:new_webmention) { Webmention.find_by(source_url: source_url, target_url: target_url) }

      it 'returns HTTP created' do
        create_webmention
        expect(response).to have_http_status(:created)
      end

      it 'set received_at on the new webmention' do
        create_webmention
        expect(new_webmention.received_at).not_to be_nil
      end

      it 'set the Location header to the URL of the webmention status' do
        create_webmention
        expect(response.headers['Location']).to eq(webmention_url(new_webmention.short_uid))
      end

      it 'queues the webmention for verification' do
        expect { create_webmention }.to change(VerifyWebmentionWorker.jobs, :size).by(1)
      end
    end
  end

  context 'with invalid webmention' do
    subject(:create_webmention) { post '/webmentions', params: { source: source_url, target: target_url } }

    let(:source_url) { Faker::Internet.url }
    let(:target_url) { "#{Rails.configuration.x.site.url}/non-existent-post" }
    let(:new_webmention) { Webmention.find_by(source_url: source_url, target_url: target_url) }

    it 'returns HTTP bad request' do
      create_webmention
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns a description of the error' do
      create_webmention
      expect(JSON.parse(response.body)).to include('error_description')
    end
  end

  describe 'GET /webmentions/:id' do
    context 'with a valid webmention as HTML' do
      let(:webmention) do
        FactoryBot.create(:webmention, source_url: Faker::Internet.url, target_url: target_post.permalink_url)
      end

      before { get "/webmentions/#{webmention.short_uid}" }

      it 'returns HTTP success' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'with an invalid webmention' do
      it 'returns HTTP not found' do
        get '/webmentions/abc123'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
