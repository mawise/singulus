# frozen_string_literal: true

# Publishes content to Hugo.
class DeleteWorker < ApplicationWorker
  include GitHubManipulator

  sidekiq_options retries: 10, lock: :while_executing, on_conflict: :reschedule, queue: 'hugo'

  def perform(id, hugo_source_path)
    file = github.contents(github_repo, path: hugo_source_path, ref: github_branch)
    sha = file.sha
    message = "Deleting post #{id}"
    github.delete_contents(github_repo, hugo_source_path, message, sha, branch: github_branch)
  rescue Octokit::NotFound => e
    Rails.logger.info("Tried to delete the post but it was not found: #{id}")
  end
end
