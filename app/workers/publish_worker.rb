# frozen_string_literal: true

# Publishes content to Hugo.
class PublishWorker < ApplicationWorker
  include Rails.application.routes.url_helpers
  include GitHubManipulator

  sidekiq_options retries: 10, lock: :while_executing, on_conflict: :reschedule, queue: 'hugo'

  def perform(action, id)
    find_post(id)

    case action
    when 'create'
      perform_create
    when 'update'
      perform_update
    end
  rescue Octokit::NotFound
    Rails.logger.info("Tried to update the post but it was not found: #{id}")
  end

  private

  attr_reader :post

  def find_post(id)
    @post = Post.includes(:webmentions_as_target).find(id)
  end

  def path
    post.hugo_source_path
  end

  def front_matter # rubocop:disable Metrics/AbcSize
    h = default_front_matter
    h[:categories] = post.categories if Array(post.categories).any?
    h[:photos] = photos if post.photos.any?
    h[:webmentions] = webmentions if post.webmentions_as_target.any?
    h
  end

  def default_front_matter
    {
      id: post.id,
      slug: post.slug,
      date: post.published_at.strftime('%Y-%m-%dT%H:%M:%S%:z')
    }
  end

  def photos
    post.photos.map do |a|
      {
        url: a.file_url,
        alt: a.alt
      }
    end
  end

  def webmentions
    post.webmentions_as_target.all.map(&:as_front_matter_json)
  end

  def content
    <<~CONTENT
      #{front_matter.deep_stringify_keys.to_yaml}
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
