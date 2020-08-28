# frozen_string_literal: true

class Post < ApplicationRecord
  # Associations and helpers for post citations.
  module Citations
    extend ActiveSupport::Concern

    included do
      has_many :bookmarks, -> { where(post_rel: 'bookmark') }, class_name: 'Citation', dependent: :destroy # rubocop:disable Rails/InverseOf
      accepts_nested_attributes_for :bookmarks, allow_destroy: true

      has_many :recipients, -> { where(post_rel: 'reply') }, class_name: 'Citation', dependent: :destroy # rubocop:disable Rails/InverseOf
      accepts_nested_attributes_for :recipients, allow_destroy: true

      has_many :likes, -> { where(post_rel: 'like') }, class_name: 'Citation', dependent: :destroy # rubocop:disable Rails/InverseOf
      accepts_nested_attributes_for :likes, allow_destroy: true

      has_many :reposts, -> { where(post_rel: 'repost') }, class_name: 'Citation', dependent: :destroy # rubocop:disable Rails/InverseOf
      accepts_nested_attributes_for :reposts, allow_destroy: true
    end
  end
end
