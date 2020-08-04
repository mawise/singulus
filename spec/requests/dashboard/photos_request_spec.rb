# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/dashboard/photos', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET /dashboard/photos' do
    it 'returns HTTP success' do
      get '/dashboard/photos'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /dashboard/photos' do
    let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/photos/sunset.jpg'), 'image/jpeg') }
    let(:params) { { photo: { file: file, alt: 'some alt text' } } }

    it 'redirects to the new photo' do
      post '/dashboard/photos', params: params
      new_photo = Photo.where('file_data @> ?', { metadata: { filename: 'sunset.jpg' } }.to_json).first
      expect(response).to redirect_to(dashboard_photo_path(new_photo))
    end
  end

  context 'with existing photo' do
    let(:photo) { FactoryBot.create(:photo) }

    describe 'GET /dashboard/photos/:id' do
      it 'returns HTTP success' do
        get "/dashboard/photos/#{photo.id}"
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PATCH /dashboard/photos/:id' do
      let(:params) { { photo: { alt: 'new alt text' } } }

      it 'redirects to the photo' do
        patch "/dashboard/photos/#{photo.id}", params: params
        expect(response).to redirect_to(dashboard_photo_path(photo))
      end
    end

    describe 'DELETE /dashboard/photos/:id' do
      it 'redirects to /photos' do
        delete "/dashboard/photos/#{photo.id}"
        expect(response).to redirect_to(dashboard_photos_path)
      end
    end
  end
end
