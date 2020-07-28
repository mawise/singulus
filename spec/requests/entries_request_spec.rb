require 'rails_helper'

RSpec.describe 'Entries', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET /entries' do
    it 'returns HTTP success' do
      get '/entries'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /entries' do
    let(:content) { "new entry #{DateTime.now}" }
    let(:params) { { entry: { content: content } } }

    it 'redirects to the new entry' do
      post '/entries', params: params
      new_entry = Entry.find_by(content: content)
      expect(response).to redirect_to(entry_path(new_entry))
    end

    it 'queues the entry for publication' do
      expect { post '/entries', params: params }.to change(PublishWorker.jobs, :size).by(1)
    end
  end

  context 'with existing entry' do
    let(:entry) { FactoryBot.create(:note, author: user) }

    describe 'GET /entries/:id' do
      it 'returns HTTP success' do
        get "/entries/#{entry.id}"
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PATCH /entries/:id' do
      let(:params) { { entry: { content: 'new content' } } }

      it 'redirects to the entry' do
        patch "/entries/#{entry.id}", params: params
        expect(response).to redirect_to(entry_path(entry))
      end

      it 'queues the entry for re-publication' do
        expect { patch "/entries/#{entry.id}", params: params }.to change(PublishWorker.jobs, :size).by(1)
      end
    end

    describe 'DELETE /entries/:id' do
      it 'redirects to /entries' do
        delete "/entries/#{entry.id}"
        expect(response).to redirect_to(entries_path)
      end

      it 'queues the entry for deletion' do
        expect { delete "/entries/#{entry.id}" }.to change(DeleteWorker.jobs, :size).by(1)
      end
    end
  end
end
