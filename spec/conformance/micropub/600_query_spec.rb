# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/contexts/micropub'

RSpec.describe 'Micropub Server Implementation Report - Query', type: :request do
  include_context 'when authenticated as a valid Micropub client'

  before { get '/micropub', params: params, headers: headers }

  # https://micropub.rocks/server-tests/600?endpoint=501
  describe '600 - Configuration Query' do
    let(:params) { { q: 'config' } }

    it 'returns HTTP 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns a JSON object' do
      expect(JSON.parse(response.body)).to be_a(Hash)
    end
  end

  # https://micropub.rocks/server-tests/601?endpoint=501
  pending '601 - Syndication Endpoint Query'

  # https://micropub.rocks/server-tests/602?endpoint=501
  pending '602 - Source Query (All Properties)'

  # https://micropub.rocks/server-tests/603?endpoint=501
  pending '603 - Source Query (Specific Properties)'
end
