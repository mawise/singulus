# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/dashboard', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET /dashboard' do
    it 'returns HTTP success' do
      get '/dashboard'
      expect(response).to have_http_status(:success)
    end
  end
end
