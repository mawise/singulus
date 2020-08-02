# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/posts', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET /posts' do
    it 'returns HTTP success' do
      get '/posts'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /posts' do
    let(:content) { "new post #{DateTime.now}" }
    let(:params) { { post: { content: content } } }

    it 'redirects to the new post' do
      post '/posts', params: params
      new_post = Post.find_by(content: content)
      expect(response).to redirect_to(post_path(new_post))
    end

    it 'queues the post for publication' do
      expect { post '/posts', params: params }.to change(PublishWorker.jobs, :size).by(1)
    end
  end

  context 'with existing post' do
    let(:post) { FactoryBot.create(:note, author: user) }

    describe 'GET /posts/:id' do
      it 'returns HTTP success' do
        get "/posts/#{post.id}"
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PATCH /posts/:id' do
      let(:params) { { post: { content: 'new content' } } }

      it 'redirects to the post' do
        patch "/posts/#{post.id}", params: params
        expect(response).to redirect_to(post_path(post))
      end

      it 'queues the post for re-publication' do
        expect { patch "/posts/#{post.id}", params: params }.to change(PublishWorker.jobs, :size).by(1)
      end
    end

    describe 'DELETE /posts/:id' do
      it 'redirects to /posts' do
        delete "/posts/#{post.id}"
        expect(response).to redirect_to(posts_path)
      end

      it 'queues the post for deletion' do
        expect { delete "/posts/#{post.id}" }.to change(DeleteWorker.jobs, :size).by(1)
      end
    end
  end
end
