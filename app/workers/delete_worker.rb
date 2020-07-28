# frozen_string_literal: true

# Publishes content to Hugo.
class DeleteWorker < ApplicationWorker
  include GitHubManipulator

  def perform(entry)
    path = "content/notes/#{entry['short_uid']}.md"
    file = github.contents(github_repo, path: path, ref: github_branch)
    sha = file.sha
    message = "Deleting entry #{entry['short_uid']}"
    github.delete_contents(github_repo, path, message, sha, branch: github_branch)
  end
end
