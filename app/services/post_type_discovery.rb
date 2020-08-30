# frozen_string_literal: true

# Post type discovery based on https://indieweb.org/post-type-discovery
class PostTypeDiscovery
  attr_reader :post

  def call(post) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    @post = post

    return 'rsvp' if post.rsvp.present?
    return 'reply' if any_citations?('reply')
    return 'repost' if any_citations?('repost')
    return 'like' if any_citations?('like')
    return 'bookmark' if any_citations?('bookmark')

    # return 'audio' if audio.any?
    # return 'video' if videos.any?
    return 'photo' if any_photos?

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

  def any_citations?(rel)
    post.references.any? { |r| r.rel == rel }
  end

  def any_photos?
    post.photo_attachments.any?
  end
end
