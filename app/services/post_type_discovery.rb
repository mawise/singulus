# frozen_string_literal: true

# Post type discovery based on https://indieweb.org/post-type-discovery
class PostTypeDiscovery
  def call(post) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    return 'rsvp' if post.rsvp.present?
    return 'reply' if post.recipients.any?
    return 'repost' if post.reposts.any?
    return 'like' if post.likes.any?
    return 'bookmark' if post.bookmarks.any?

    # return 'audio' if audio.any?
    # return 'video' if videos.any?
    return 'photo' if post.photos.any?

    if post.content.present?
      normalized_content = post.content.strip.squeeze
    elsif post.summary.present?
      normalized_content = post.summary.strip.squeeze
    else
      return 'note'
    end

    return 'note' if post.name.blank?

    normalized_name = post.name.strip.squeeze
    return 'article' unless /\A#{Regexp.escape(normalized_name)}/.match?(normalized_content)

    'note'
  end
end
