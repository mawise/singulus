# frozen_string_literal: true

class Post < ApplicationRecord
  # Webmention associations and helpers for posts.
  module Webmentions
    extend ActiveSupport::Concern

    included do
      has_many :webmentions_as_source, foreign_key: :source_id,
                                       class_name: 'Webmention', inverse_of: :source, dependent: :nullify
      has_many :webmentions_as_target, foreign_key: :target_id,
                                       class_name: 'Webmention', inverse_of: :target, dependent: :nullify
    end
  end
end
