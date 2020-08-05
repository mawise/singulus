# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/dashboard/posts', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET /dashboard/posts' do
    it 'returns HTTP success' do
      get '/dashboard/posts'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /dashboard/posts' do
    let(:content) { "new post #{DateTime.now}" }
    let(:params) { { post: { content: content } } }
    let(:new_post) { Post.find_by(content: content) }

    it 'redirects to the new post' do
      post '/dashboard/posts', params: params
      expect(response).to redirect_to(dashboard_post_path(new_post))
    end

    it 'queues the post for publication' do
      expect { post '/dashboard/posts', params: params }.to change(PublishWorker.jobs, :size).by(1)
    end

    it 'creates a shortlink for the post' do
      post '/dashboard/posts', params: params
      expect(new_post.shortlinks.count).to eq(1)
    end

    it 'sets the shortlink to the short ID of the post' do
      post '/dashboard/posts', params: params
      expect(new_post.shortlinks.first.link).to eq(new_post.short_uid)
    end

    it 'sets the shortlink target to the permalink URL of the post' do
      post '/dashboard/posts', params: params
      expect(new_post.shortlinks.first.target_url).to eq(new_post.permalink_url)
    end
  end

  context 'with existing post' do
    let(:post) { FactoryBot.create(:note, author: user) }

    describe 'GET /dashboard/posts/:id' do
      it 'returns HTTP success' do
        get "/dashboard/posts/#{post.id}"
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PATCH /dashboard/posts/:id' do
      let(:params) { { post: { content: 'new content' } } }

      it 'redirects to the post' do
        patch "/dashboard/posts/#{post.id}", params: params
        expect(response).to redirect_to(dashboard_post_path(post))
      end

      it 'queues the post for re-publication' do
        expect { patch "/dashboard/posts/#{post.id}", params: params }.to change(PublishWorker.jobs, :size).by(1)
      end
    end

    describe 'DELETE /dashboard/posts/:id' do
      it 'redirects to /dashboard/posts' do
        delete "/dashboard/posts/#{post.id}"
        expect(response).to redirect_to(dashboard_posts_path)
      end

      it 'queues the post for deletion' do
        expect { delete "/dashboard/posts/#{post.id}" }.to change(DeleteWorker.jobs, :size).by(1)
      end
    end
  end
end
