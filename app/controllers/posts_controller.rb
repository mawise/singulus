# frozen_string_literal: true

# Manages posts.
class PostsController < ApplicationController
  before_action :authenticate_user!

  before_action :find_post, only: %i[show edit update destroy]

  def index
    @entries = Post.order(published_at: :desc, created_at: :desc).page(params[:page])
  end

  def new
    @post = Post.new
    @post.assets.build
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user
    @post.published_at = Time.now.utc
    if @post.save_unique
      PublishWorker.perform_async('create', @post.id)
      redirect_to post_path(@post), notice: 'Post was successfully created'
    else
      render :new
    end
  end

  def show; end

  def edit
    @post.assets.build if @post.assets.empty?
  end

  def update
    if @post.update(post_params)
      PublishWorker.perform_async('update', @post.id)
      redirect_to post_path(@post), notice: 'Post was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    DeleteWorker.perform_async(@post.id, @post.hugo_source_path)
    redirect_to posts_path
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(
      :name, :content, :slug, :summary, :category_names,
      assets_attributes: %i[alt file]
    )
  end
end
