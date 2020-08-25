# frozen_string_literal: true

# Generates post front matter.
module PostFrontMatter
  extend ActiveSupport::Concern

  def front_matter # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    h = {
      id: id,
      slug: slug,
      date: published_at&.iso8601 || created_at&.iso8601,
      draft: draft?
    }

    h[:metadata] = metadata
    h[:categories] = categories if Array(categories).any?
    h[:featured] = featured.as_front_matter_json if featured.present?
    h[:name] = name if name.present?
    h[:title] = name if name.present?
    h[:summary] = summary if summary.present?
    h[:webmentions] = webmentions_front_matter if webmentions_as_target.any?

    h[:photos] = photos_front_matter if type == 'photo'
    h[:cite] = h[:bookmark_of] = bookmark_of_front_matter if type == 'bookmark'
    h[:cite] = h[:in_reply_to] = in_reply_to_front_matter if %w[reply rsvp].include?(type)
    h[:cite] = h[:like_of] = like_of_front_matter if type == 'like'
    h[:cite] = h[:repost_of] = repost_of_front_matter if type == 'repost'
    h[:rsvp] = rsvp if rsvp.present?

    h
  end

  def to_front_matter_json
    front_matter.to_json
  end

  def to_front_matter_yaml
    front_matter.deep_stringify_keys.to_yaml
  end

  def photos_front_matter
    photos.map(&:as_front_matter_json)
  end

  def bookmark_of_front_matter
    bookmark_of
  end

  def in_reply_to_front_matter
    in_reply_to
  end

  def like_of_front_matter
    like_of
  end

  def repost_of_front_matter
    repost_of
  end

  def webmentions_front_matter
    webmentions_as_target.all.map(&:as_front_matter_json)
  end
end
