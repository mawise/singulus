# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/contexts/micropub'

RSpec.describe 'Micropub Server Implementation Report - Creating Posts (Form-Encoded)', type: :request do
  include_context 'when authenticated as a valid Micropub client'

  # https://micropub.rocks/server-tests/100?endpoint=501
  describe '100 - Create an h-entry post (form-encoded)' do
    let(:content) { 'Micropub test of creating a basic h-entry' }
    let(:params) { { h: 'entry', content: content } }

    before { post '/micropub', params: params, headers: headers }

    it 'returns HTTP accepted' do
      expect(response).to have_http_status(:accepted)
    end

    it 'returns a Location header with the permalink URL of the new post' do
      post = Post.find_by(content: content)
      expect(response.headers['Location']).to eq(post.permalink_url)
    end

    it 'queues the post for publication' do
      expect(HugoPublishWorker.jobs.size).to eq(1)
    end
  end

  # https://micropub.rocks/server-tests/101?endpoint=501
  describe '101 - Create an h-entry post with multiple categories (form-encoded)' do
    let(:content) { 'Micropub test of creating an h-entry with categories. This post should have two categories, test1 and test2' } # rubocop:disable Layout/LineLength
    let(:categories) { %w[test1 test2] }
    let(:params) { { h: 'entry', content: content, category: categories } }
    let(:new_post) { Post.find_by(content: content) }

    before { post '/micropub', params: params, headers: headers }

    it 'returns HTTP accepted' do
      expect(response).to have_http_status(:accepted)
    end

    it 'returns a Location header with the permalink URL of the new post' do
      expect(response.headers['Location']).to eq(new_post.permalink_url)
    end

    it 'queues the post for publication' do
      expect(HugoPublishWorker.jobs.size).to eq(1)
    end

    it 'sets categories on the post' do
      expect(new_post.categories).to eq(%w[test1 test2])
    end
  end

  # https://micropub.rocks/server-tests/104?endpoint=501
  describe '104 - Create an h-entry with a photo referenced by URL (form-encoded)' do
    context 'with an existing photo URL' do
      let(:photo) { FactoryBot.create(:photo) }
      let(:content) { 'Micropub test of creating a photo referenced by URL' }
      let(:params) do
        {
          "h": 'entry',
          "content": content,
          "photo": photo.file_url
        }
      end
      let(:new_post) { Post.find_by(content: content) }

      before { post '/micropub', params: params, headers: headers }

      it 'returns HTTP accepted' do
        expect(response).to have_http_status(:accepted)
      end

      it 'returns a Location header with the permalink URL of the new post' do
        expect(response.headers['Location']).to eq(new_post.permalink_url)
      end

      it 'queues the post for publication' do
        expect(HugoPublishWorker.jobs.size).to eq(1)
      end

      it 'links the existing photo to the post' do
        expect(photo.reload.post_ids).to include(new_post.id)
      end
    end

    context 'with a remote URL' do
      let(:content) { 'Micropub test of creating a photo referenced by URL. This post should include a photo of a sunset.' } # rubocop:disable Layout/LineLength
      let(:photo_url) { Faker::Internet.url(path: '/image.jpg') }
      let(:params) do
        {
          "h": ['entry'],
          "content": content,
          "photo": photo_url
        }
      end
      let(:new_post) { Post.find_by(content: content) }

      before do
        file = File.open(Dir[Rails.root.join('spec/fixtures/photos/*.jpeg')].sample)
        stub_request(:any, photo_url).to_return(body: file, status: 200)
        post '/micropub', params: params, headers: headers
      end

      it 'returns HTTP accepted' do
        expect(response).to have_http_status(:accepted)
      end

      it 'returns a Location header with the permalink URL of the new post' do
        expect(response.headers['Location']).to eq(new_post.permalink_url)
      end

      it 'queues the post for publication' do
        expect(HugoPublishWorker.jobs.size).to eq(1)
      end

      it 'creates a new photo with the post' do
        expect(new_post.photos.count).to eq(1)
      end
    end
  end

  # https://micropub.rocks/server-tests/107?endpoint=501
  describe '107 - Create an h-entry post with one category (form-encoded)' do
    let(:content) { 'Micropub test of creating an h-entry with one category. This post should have one category, test1' } # rubocop:disable Layout/LineLength
    let(:params) { { h: 'entry', content: content, category: 'test1' } }
    let(:new_post) { Post.find_by(content: content) }

    before { post '/micropub', params: params, headers: headers }

    it 'returns HTTP accepted' do
      expect(response).to have_http_status(:accepted)
    end

    it 'returns a Location header with the permalink URL of the new post' do
      expect(response.headers['Location']).to eq(new_post.permalink_url)
    end

    it 'queues the post for publication' do
      expect(HugoPublishWorker.jobs.size).to eq(1)
    end

    it 'sets categories on the post' do
      expect(new_post.categories).to eq(%w[test1])
    end
  end
end
