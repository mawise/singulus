# frozen_string_literal: true

# Post type discovery based on https://indieweb.org/post-type-discovery
class PostTypeDiscovery
  def call(post) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    return 'rsvp' if post.rsvp.present?
    return 'reply' if post.in_reply_to_url.present?
    return 'repost' if post.repost_of_url.present?
    return 'like' if post.like_of_url.present?
    return 'bookmark' if post.bookmark_of_url.present?

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
