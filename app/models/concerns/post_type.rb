# frozen_string_literal: true

# Helpers for determining an post's post type.
module PostType
  extend ActiveSupport::Concern

  # Returns the post type of the post.
  #
  # Currently supports:
  # - [article](https://indieweb.org/article)
  # - [note](https://indieweb.org/note)
  #
  # @see https://indieweb.org/posts
  # @see https://indieweb.org/post-type-discovery#Algorithm
  def post_type # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if content.present?
      normalized_content = content.strip.squeeze
    elsif summary.present?
      normalized_content = summary.strip.squeeze
    else
      return 'note'
    end

    return 'note' if name.blank?

    normalized_name = name.strip.squeeze
    return 'article' unless /\A#{Regexp.escape(normalized_name)}/.match?(normalized_content)

    'note'
  end

  def permalink_url
    prefix = Rails.configuration.x.site.url
    case post_type
    when 'article'
      "#{prefix}/articles/#{slug}"
    when 'note'
      "#{prefix}/notes/#{slug}"
    end
  end

  def hugo_source_path
    case post_type
    when 'article'
      "content/articles/#{id}.md"
    when 'note'
      "content/notes/#{id}.md"
    end
  end
end
