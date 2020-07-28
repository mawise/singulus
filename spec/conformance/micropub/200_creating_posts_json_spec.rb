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

    it 'returns a Location header with the permalink URL of the new entry' do
      entry = Entry.find_by(content: content)
      expect(response.headers['Location']).to eq(entry.permalink_url)
    end

    it 'queues the note for publication' do
      expect(PublishWorker.jobs.size).to eq(1)
    end
  end

  # https://micropub.rocks/server-tests/201?endpoint=501
  pending '201 - Create an h-entry post with multiple categories (JSON)'

  # https://micropub.rocks/server-tests/202?endpoint=501
  pending '202 - Create an h-entry with HTML content (JSON)'

  # https://micropub.rocks/server-tests/203?endpoint=501
  pending '203 - Create an h-entry with a photo referenced by URL (JSON)'

  # https://micropub.rocks/server-tests/204?endpoint=501
  pending '204 - Create an h-entry post with a nested object (JSON)'

  # https://micropub.rocks/server-tests/205?endpoint=501
  pending '205 - Create an h-entry post with a photo with alt text (JSON)'

  # https://micropub.rocks/server-tests/206?endpoint=501
  pending '206 - Create an h-entry with multiple photos referenced by URL (JSON)'
end
