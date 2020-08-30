# frozen_string_literal: true

class Post < ApplicationRecord
  # Associations and helpers for post citations.
  module Citations
    extend ActiveSupport::Concern

    included do
      has_many :references, inverse_of: :post, dependent: :destroy
      has_many :citations, through: :references, inverse_of: :posts
      accepts_nested_attributes_for :references, allow_destroy: true, reject_if: :invalid_reference_attributes?

      has_many :bookmark_references, -> { where(rel: 'bookmark') },
               class_name: 'Reference', foreign_key: :post_id, inverse_of: :post
      has_many :bookmarks, through: :bookmark_references, class_name: 'Citation', inverse_of: :posts, source: :citation

      has_many :like_references, -> { where(rel: 'like') },
               class_name: 'Reference', foreign_key: :post_id, inverse_of: :post
      has_many :likes, through: :bookmark_references, class_name: 'Citation', inverse_of: :posts, source: :citation

      has_many :reply_references, -> { where(rel: 'reply') },
               class_name: 'Reference', foreign_key: :post_id, inverse_of: :post
      has_many :replies, through: :reply_references, class_name: 'Citation', inverse_of: :posts, source: :citation

      has_many :repost_references, -> { where(rel: 'repost') },
               class_name: 'Reference', foreign_key: :post_id, inverse_of: :post
      has_many :reposts, through: :repost_references, class_name: 'Citation', inverse_of: :posts, source: :citation
    end

    protected

    def invalid_reference_attributes?(attrs)
      attrs[:citation_id].blank? && attrs[:citation_attributes].blank?
    end
  end
end
