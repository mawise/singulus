# frozen_string_literal: true

# Publishes content to Hugo.
class PublishWorker < ApplicationWorker
  include GitHubManipulator

  def perform(action, id)
    find_post(id)

    case action
    when 'create'
      perform_create
    when 'update'
      perform_update
    end
  end

  private

  attr_reader :post

  def find_post(id)
    @post = Post.find(id)
  end

  def path
    post.hugo_source_path
  end

  def content
    <<~CONTENT
      ---
      id: "#{post.id}"
      slug: "#{post.slug}"
      date: "#{post.published_at.strftime('%Y-%m-%dT%H:%M:%S%:z')}"
      ---

      #{post.content}
    CONTENT
  end

  def sha
    github.contents(github_repo, path: path, ref: github_branch).sha
  end

  def perform_create
    message = "Creating post #{post.id}"
    github.create_contents(github_repo, path, message, content, branch: github_branch)
  end

  def perform_update
    message = "Updating post #{post.id}"
    github.update_contents(github_repo, path, message, sha, content, branch: github_branch)
  end
end
