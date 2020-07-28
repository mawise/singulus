# frozen_string_literal: true

# Publishes content to Hugo.
class PublishWorker < ApplicationWorker
  include GitHubManipulator

  def perform(action, type, id)
    find_entry(type, id)
    @path = "content/notes/#{entry.short_uid}.md"

    case action
    when 'create'
      perform_create
    when 'update'
      perform_update
    end
  end

  private

  attr_reader :entry, :path

  def find_entry(type, id)
    klass = type.classify.constantize
    @entry = klass.find(id)
  end

  def content
    <<~CONTENT
      ---
      slug: "#{entry.short_uid}"
      date: "#{entry.published_at.strftime('%Y-%m-%dT%H:%M:%S%:z')}"
      ---

      #{entry.content}
    CONTENT
  end

  def sha
    github.contents(github_repo, path: path, ref: github_branch).sha
  end

  def perform_create
    message = "Creating entry #{entry.short_uid}"
    github.create_contents(github_repo, path, message, content, branch: github_branch)
  end

  def perform_update
    message = "Updating entry #{entry.short_uid}"
    github.update_contents(github_repo, path, message, sha, content, branch: github_branch)
  end
end
