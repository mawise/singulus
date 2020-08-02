# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Micropub Server Implementation Report - Creating Posts (JSON)', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:application) }
  let(:access_token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

  let(:headers) do
    {
      'Authorization' => "Bearer #{access_token.token}",
      'Content-Type' => 'application/json'
    }
  end

  before { post '/micropub', params: params, headers: headers }

  # https://micropub.rocks/server-tests/200?endpoint=501
  describe '200 - Create an h-entry post (JSON)' do
    let(:content) { 'Micropub test of creating an h-entry with a JSON request' }
    let(:params) do
      {
        "type": ['h-entry'],
        "properties": {
          "content": [content]
        }
      }.to_json
    end

    it 'returns HTTP accepted' do
      expect(response).to have_http_status(:accepted)
    end

    it 'returns a Location header with the permalink URL of the new post' do
      post = Post.find_by(content: content)
      expect(response.headers['Location']).to eq(post.permalink_url)
    end

    it 'queues the note for publication' do
      expect(PublishWorker.jobs.size).to eq(1)
    end
  end

  # https://micropub.rocks/server-tests/201?endpoint=501
  describe '201 - Create an h-entry post with multiple categories (JSON)' do
    let(:content) { 'Micropub test of creating an h-entry with a JSON request containing multiple categories. This post should have two categories, test1 and test2.' } # rubocop:disable Layout/LineLength
    let(:params) do
      {
        "type": ['h-entry'],
        "properties": {
          "content": [content],
          "category": %w[
            test1
            test2
          ]
        }
      }.to_json
    end
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

  # https://micropub.rocks/server-tests/202?endpoint=501
  pending '202 - Create an h-entry with HTML content (JSON)'

  # https://micropub.rocks/server-tests/203?endpoint=501
  describe '203 - Create an h-entry with a photo referenced by URL (JSON)' do
    context 'with an existing photo URL' do
      let(:photo) { Photo.create(file: fixture_file_upload(Rails.root.join('spec/fixtures/photos/4.1.01.jpeg'), 'image/jpeg')) } # rubocop:disable Layout/LineLength
      let(:content) { 'Micropub test of creating a photo referenced by URL. This post should include a photo of a person.' } # rubocop:disable Layout/LineLength
      let(:params) do
        {
          "type": ['h-entry'],
          "properties": {
            "content": [content],
            "photo": [photo.file_url]
          }
        }.to_json
      end
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

      it 'links the existing photo to the post' do
        expect(photo.reload.post_id).to eq(new_post.id)
      end
    end

    context 'with a remote URL' do
      let(:content) { 'Micropub test of creating a photo referenced by URL. This post should include a photo of a sunset.' } # rubocop:disable Layout/LineLength
      let(:params) do
        {
          "type": ['h-entry'],
          "properties": {
            "content": [content],
            "photo": ['https://raw.githubusercontent.com/craftyphotons/singulus/main/spec/fixtures/photos/sunset.jpg']
          }
        }.to_json
      end
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

      it 'creates a new photo with the post' do
        expect(new_post.photos.count).to eq(1)
      end
    end
  end

  # https://micropub.rocks/server-tests/204?endpoint=501
  pending '204 - Create an h-entry post with a nested object (JSON)'

  # https://micropub.rocks/server-tests/205?endpoint=501
  describe '205 - Create an h-entry post with a photo with alt text (JSON)' do
    context 'with an existing photo URL' do
      let(:photo) { Photo.create(file: fixture_file_upload(Rails.root.join('spec/fixtures/photos/4.1.01.jpeg'), 'image/jpeg')) } # rubocop:disable Layout/LineLength
      let(:content) { 'Micropub test of creating a photo referenced by URL with alt text. This post should include a photo of a person.' } # rubocop:disable Layout/LineLength
      let(:alt) { 'Photo of a person' }
      let(:params) do
        {
          "type": ['h-entry'],
          "properties": {
            "content": [content],
            "photo": [
              {
                "value": photo.file_url,
                "alt": alt
              }
            ]
          }
        }.to_json
      end
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

      it 'links the photo to the post' do
        expect(photo.reload.post_id).to eq(new_post.id)
      end

      it 'updates the alt text on the photo' do
        expect(photo.reload.alt).to eq(alt)
      end
    end

    context 'with a remote URL' do
      let(:content) { 'Micropub test of creating a photo referenced by URL with alt text. This post should include a photo of a sunset.' } # rubocop:disable Layout/LineLength
      let(:alt) { 'Photo of a sunset' }
      let(:params) do
        {
          "type": ['h-entry'],
          "properties": {
            "content": [content],
            "photo": [
              {
                "value": 'https://raw.githubusercontent.com/craftyphotons/singulus/main/spec/fixtures/photos/sunset.jpg',
                "alt": alt
              }
            ]
          }
        }.to_json
      end
      let(:new_post) { Post.find_by(content: content) }

      it 'returns HTTP accepted' do
        expect(response).to have_http_status(:accepted)
      end

      it 'returns a Location header with the permalink URL of the new post' do
        expect(response.headers['Location']).to eq(new_post.permalink_url)
      end

      it 'creates a new photo with the post' do
        expect(new_post.photos.count).to eq(1)
      end

      it 'sets the alt text on the photo' do
        expect(new_post.photos.first.alt).to eq(alt)
      end
    end
  end

  # https://micropub.rocks/server-tests/206?endpoint=501
  describe '206 - Create an h-entry with multiple photos referenced by URL (JSON)' do
    context 'with a existing photo URLs' do
      let(:first_photo) { Photo.create(file: fixture_file_upload(Rails.root.join('spec/fixtures/photos/4.1.01.jpeg'), 'image/jpeg')) } # rubocop:disable Layout/LineLength
      let(:second_photo) { Photo.create(file: fixture_file_upload(Rails.root.join('spec/fixtures/photos/4.1.02.jpeg'), 'image/jpeg')) } # rubocop:disable Layout/LineLength
      let(:content) { 'Micropub test of creating a photo referenced by URL. This post should include a photo of a person.' } # rubocop:disable Layout/LineLength
      let(:params) do
        {
          "type": ['h-entry'],
          "properties": {
            "content": [content],
            "photo": [first_photo.file_url, second_photo.file_url]
          }
        }.to_json
      end
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

      it 'links the first existing photo to the post' do
        expect(first_photo.reload.post_id).to eq(new_post.id)
      end

      it 'links the second existing photo to the post' do
        expect(second_photo.reload.post_id).to eq(new_post.id)
      end
    end

    context 'with remote URLs' do
      let(:content) { 'Micropub test of creating multiple photos referenced by URL. This post should include a photo of a city at night.' } # rubocop:disable Layout/LineLength
      let(:params) do
        {
          "type": ['h-entry'],
          "properties": {
            "content": [content],
            "photo": [
              'https://raw.githubusercontent.com/craftyphotons/singulus/main/spec/fixtures/photos/sunset.jpg',
              'https://raw.githubusercontent.com/craftyphotons/singulus/main/spec/fixtures/photos/city-at-night.jpg'
            ]
          }
        }.to_json
      end
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

      it 'creates a new photo with the post' do
        expect(new_post.photos.count).to eq(2)
      end
    end
  end
end
