# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/contexts/micropub'

RSpec.describe 'Micropub Server Implementation Report - Creating Posts (Multipart)', type: :request do
  include_context 'when authenticated as a valid Micropub client'

  let(:content_type) { 'multipart/form-data' }

  before { post '/micropub', params: params, headers: headers }

  # https://micropub.rocks/server-tests/300?endpoint=501
  describe '300 - Create an h-entry with a photo (multipart)' do
    let(:content) { 'Nice sunset tonight' }
    let(:photo) { fixture_file_upload(Rails.root.join('spec/fixtures/photos/4.1.01.jpeg'), 'image/jpeg') }
    let(:params) { { h: 'entry', content: content, photo: photo } }
    let(:new_post) { Post.find_by(content: content) }

    it 'returns HTTP accepted' do
      expect(response).to have_http_status(:accepted)
    end

    it 'returns a Location header with the permalink URL of the new post' do
      expect(response.headers['Location']).to eq(new_post.permalink_url)
    end

    it 'queues the post for publication' do
      expect(HugoPublishWorker.jobs.size).to eq(1)
    end

    it 'creates an Photo for the photo' do
      expect(new_post.photos.first.file).not_to be_nil
    end
  end

  # https://micropub.rocks/server-tests/301?endpoint=501
  describe '301 - Create an h-entry with two photos (multipart)' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:content) { 'Nice sunset tonight' }
    let(:first_photo) { fixture_file_upload(Rails.root.join('spec/fixtures/photos/4.1.01.jpeg'), 'image/jpeg') }
    let(:second_photo) { fixture_file_upload(Rails.root.join('spec/fixtures/photos/4.1.02.jpeg'), 'image/jpeg') }
    let(:params) { { h: 'entry', content: content, photo: [first_photo, second_photo] } }
    let(:new_post) { Post.find_by(content: content) }

    it 'returns HTTP accepted' do
      expect(response).to have_http_status(:accepted)
    end

    it 'returns a Location header with the permalink URL of the new post' do
      expect(response.headers['Location']).to eq(new_post.permalink_url)
    end

    it 'queues the post for publication' do
      expect(HugoPublishWorker.jobs.size).to eq(1)
    end

    it 'creates each photo' do
      expect(new_post.photos.count).to eq(2)
    end
  end
end
