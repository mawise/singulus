# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Micropub Server Implementation Report - Creating Posts (Form-Encoded)', type: :request do
  let(:site_url) { 'https://example.com' }
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:application) }
  let(:access_token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

  let(:headers) do
    {
      'Authorization' => "Bearer #{access_token.token}",
      'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8'
    }
  end

  before do
    allow(Rails.configuration).to receive(:site_url) { site_url }
    post '/micropub', params: params, headers: headers
  end

  # https://micropub.rocks/server-tests/100?endpoint=501
  describe '100 - Create an h-entry post (form-encoded)' do
    let(:content) { 'Micropub test of creating a basic h-entry' }
    let(:params) { { h: 'entry', content: content } }

    it 'returns HTTP accepted' do
      expect(response).to have_http_status(:accepted)
    end

    it 'returns a Location header with the permalink URL of the new post' do
      post = Post.find_by(content: content)
      expect(response.headers['Location']).to eq(post.permalink_url)
    end

    it 'queues the post for publication' do
      expect(PublishWorker.jobs.size).to eq(1)
    end
  end

  # https://micropub.rocks/server-tests/101?endpoint=501
  describe '101 - Create an h-entry post with multiple categories (form-encoded)' do
    let(:content) { 'Micropub test of creating an h-entry with categories. This post should have two categories, test1 and test2' } # rubocop:disable Layout/LineLength
    let(:categories) { %w[test1 test2] }
    let(:params) { { h: 'entry', content: content, category: categories } }
    let(:new_post) { Post.find_by(content: content) }

    it 'returns HTTP accepted' do
      expect(response).to have_http_status(:accepted)
    end

    it 'returns a Location header with the permalink URL of the new post' do
      expect(response.headers['Location']).to eq(new_post.permalink_url)
    end

    it 'queues the post for publication' do
      expect(PublishWorker.jobs.size).to eq(1)
    end

    it 'sets categories on the post' do
      expect(new_post.categories).to eq(%w[test1 test2])
    end
  end

  # https://micropub.rocks/server-tests/104?endpoint=501
  pending '104 - Create an h-entry with a photo referenced by URL (form-encoded)'

  # https://micropub.rocks/server-tests/107?endpoint=501
  describe '107 - Create an h-entry post with one category (form-encoded)' do
    let(:content) { 'Micropub test of creating an h-entry with one category. This post should have one category, test1' } # rubocop:disable Layout/LineLength
    let(:params) { { h: 'entry', content: content, category: 'test1' } }
    let(:new_post) { Post.find_by(content: content) }

    it 'returns HTTP accepted' do
      expect(response).to have_http_status(:accepted)
    end

    it 'returns a Location header with the permalink URL of the new post' do
      expect(response.headers['Location']).to eq(new_post.permalink_url)
    end

    it 'queues the post for publication' do
      expect(PublishWorker.jobs.size).to eq(1)
    end

    it 'sets categories on the post' do
      expect(new_post.categories).to eq(%w[test1])
    end
  end
end
