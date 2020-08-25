# frozen_string_literal: true

# Publishes content to Hugo.
class HugoPublishWorker < ApplicationWorker
  include Rails.application.routes.url_helpers
  include GitHubManipulator

  sidekiq_options retries: 10, lock: :while_executing, on_conflict: :reschedule, queue: 'hugo'

  def perform(action, id)
    find_post(id)

    Retriable.retriable on: [Octokit::Conflict], on_retry: method(:log_retry), tries: 15, base_interval: 1.0 do
      perform_create if action == 'create'
      perform_update if action == 'update'
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

  def content
    <<~CONTENT
      #{post.to_front_matter_yaml}
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

  def log_retry(exception, try, elapsed_time, next_interval)
    Rails.logger.warn(
      'Encountered Git conflict when publishing post (probably due to a bulk update) - ' \
      "#{exception.class}: '#{exception.message}' - #{try} tries in #{elapsed_time} seconds and #{next_interval} seconds until the next try." # rubocop:disable Layout/LineLength
    )
  end
end
