# frozen_string_literal: true

# Publishes content to Hugo.
class DeleteWorker < ApplicationWorker
  include GitHubManipulator

  def perform(id, hugo_source_path)
    file = github.contents(github_repo, path: hugo_source_path, ref: github_branch)
    sha = file.sha
    message = "Deleting post #{id}"
    github.delete_contents(github_repo, hugo_source_path, message, sha, branch: github_branch)
  end
end
