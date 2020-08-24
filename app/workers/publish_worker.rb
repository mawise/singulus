# frozen_string_literal: true

# Publishes content to Hugo.
class PublishWorker < ApplicationWorker
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

  def front_matter # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    h = default_front_matter
    h[:categories] = post.categories if Array(post.categories).any?
    h[:featured] = post.featured.as_front_matter_json if post.featured.present?
    h[:name] = post.name if post.name.present?
    h[:summary] = post.summary if post.summary.present?
    h[:webmentions] = webmentions if post.webmentions_as_target.any?

    h[:photos] = photos if post.type == 'photo'
    h[:cite] = h[:bookmark_of] = bookmark if post.type == 'bookmark'
    h[:cite] = h[:in_reply_to] = in_reply_to if %w[reply rsvp].include?(post.type)
    h[:cite] = h[:like_of] = like_of if post.type == 'like'
    h[:cite] = h[:repost_of] = repost_of if post.type == 'repost'
    h[:rsvp] = post.rsvp if post.rsvp.present?

    h
  end

  def default_front_matter
    {
      id: post.id,
      slug: post.slug,
      date: post.published_at&.iso8601 || post.created_at&.iso8601,
      draft: post.published?
    }
  end

  def photos
    post.photos.map(&:as_front_matter_json)
  end

  def bookmark_of
    post.bookmark_of
  end

  def in_reply_to
    post.in_reply_to
  end

  def like_of
    post.like_of
  end

  def repost_of
    post.repost_of
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

  def log_retry(exception, try, elapsed_time, next_interval)
    Rails.logger.warn(
      'Encountered Git conflict when publishing post (probably due to a bulk update) - ' \
      "#{exception.class}: '#{exception.message}' - #{try} tries in #{elapsed_time} seconds and #{next_interval} seconds until the next try." # rubocop:disable Metrics/LineLength
    )
  end
end
