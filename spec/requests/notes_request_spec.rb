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
    it 'redirects to the new note' do
      content = "new note #{DateTime.now}"
      post '/notes', params: { note: { content: content } }
      new_note = Note.find_by(content: content)
      expect(response).to redirect_to(note_path(new_note))
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
      it 'redirects to the note' do
        patch "/notes/#{note.id}", params: { note: { content: 'new content' } }
        expect(response).to redirect_to(note_path(note))
      end
    end

    describe 'DELETE /notes/:id' do
      it 'redirects to /notes' do
        delete "/notes/#{note.id}"
        expect(response).to redirect_to(notes_path)
      end
    end
  end
end
