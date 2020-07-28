module EntryType
  extend ActiveSupport::Concern

  # Returns the post type of the entry.
  #
  # Currently supports:
  # - [article](https://indieweb.org/article)
  # - [note](https://indieweb.org/note)
  #
  # @see https://indieweb.org/posts
  # @see https://indieweb.org/post-type-discovery#Algorithm
  def entry_type
    if content.present?
      normalized_content = content.strip.squeeze
    elsif summary.present?
      normalized_content = summary.strip.squeeze
    else
      return 'note'
    end

    return 'note' if name.blank?

    normalized_name = name.strip.squeeze
    return 'article' unless /\A#{Regexp.escape(name)}/.match?(normalized_content)

    'note'
  end

  def permalink_url
    prefix = Rails.configuration.site_url
    case entry_type
    when 'article'
      "#{prefix}/articles/#{slug}"
    when 'note'
      "#{prefix}/notes/#{slug}"
    end
  end

  def hugo_source_path
    case entry_type
    when 'article'
      "content/articles/#{id}.md"
    when 'note'
      "content/notes/#{id}.md"
    end
  end
end
