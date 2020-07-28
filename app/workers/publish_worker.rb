# frozen_string_literal: true

# Publishes content to Hugo.
class PublishWorker < ApplicationWorker
  include GitHubManipulator

  def perform(action, id)
    find_entry(id)

    case action
    when 'create'
      perform_create
    when 'update'
      perform_update
    end
  end

  private

  attr_reader :entry

  def find_entry(id)
    @entry = Entry.find(id)
  end

  def path
    entry.hugo_source_path
  end

  def content
    <<~CONTENT
      ---
      id: "#{entry.id}"
      slug: "#{entry.slug}"
      date: "#{entry.published_at.strftime('%Y-%m-%dT%H:%M:%S%:z')}"
      ---

      #{entry.content}
    CONTENT
  end

  def sha
    github.contents(github_repo, path: path, ref: github_branch).sha
  end

  def perform_create
    message = "Creating entry #{entry.id}"
    github.create_contents(github_repo, path, message, content, branch: github_branch)
  end

  def perform_update
    message = "Updating entry #{entry.id}"
    github.update_contents(github_repo, path, message, sha, content, branch: github_branch)
  end
end
