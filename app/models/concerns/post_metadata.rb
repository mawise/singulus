# frozen_string_literal: true

# Helpers to generate post metadata.
module PostMetadata
  extend ActiveSupport::Concern

  def metadata
    {
      description: meta_description
    }.merge(opengraph_metadata).merge(twitter_metadata)
  end

  def meta_description
    return super if self[:meta_description]

    source = summary.presence || content.presence || ''
    source.gsub(/(\r)?\n/, ' ').truncate(160)
  end
end
