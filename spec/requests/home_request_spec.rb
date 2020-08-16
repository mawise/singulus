# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/', type: :request do
  describe 'GET /' do
    context 'when logged in' do
      let(:user) { FactoryBot.create(:user) }

      before { sign_in(user) }

      it 'redirects to the dashboard' do
        get '/'
        expect(response).to redirect_to(dashboard_root_path)
      end
    end

    context 'when not logged in' do
      it 'returns redirects to the login page' do
        get '/'
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
