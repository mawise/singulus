# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/', type: :request do
  describe 'GET /' do
    it 'returns HTTP success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end

  context 'when already logged in' do
    let(:user) { FactoryBot.create(:user) }

    before { sign_in(user) }

    it 'redirects to the dashboard' do
      get '/'
      expect(response).to redirect_to(dashboard_root_path)
    end
  end
end
