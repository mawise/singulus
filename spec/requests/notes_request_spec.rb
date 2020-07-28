# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET /notes' do
    it 'returns HTTP success' do
      get '/notes'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /notes' do
    let(:content) { "new note #{DateTime.now}" }
    let(:params) { { note: { content: content } } }

    it 'redirects to the new note' do
      post '/notes', params: params
      new_note = Note.find_by(content: content)
      expect(response).to redirect_to(note_path(new_note))
    end

    it 'queues the note for publication' do
      expect do
        post '/notes', params: params
      end.to change(PublishWorker.jobs, :size).by(1)
    end
  end

  context 'with existing note' do
    let(:note) { FactoryBot.create(:note, author: user) }

    describe 'GET /notes/:id' do
      it 'returns HTTP success' do
        get "/notes/#{note.id}"
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PATCH /notes/:id' do
      let(:params) { { note: { content: 'new content' } } }

      it 'redirects to the note' do
        patch "/notes/#{note.id}", params: params
        expect(response).to redirect_to(note_path(note))
      end

      it 'queues the note for re-publication' do
        expect do
          patch "/notes/#{note.id}", params: params
        end.to change(PublishWorker.jobs, :size).by(1)
      end
    end

    describe 'DELETE /notes/:id' do
      it 'redirects to /notes' do
        delete "/notes/#{note.id}"
        expect(response).to redirect_to(notes_path)
      end

      it 'queues the note for deletion' do
        expect do
          delete "/notes/#{note.id}"
        end.to change(DeleteWorker.jobs, :size).by(1)
      end
    end
  end
end
