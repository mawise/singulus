# frozen_string_literal: true

# Represents episodic or datestamped content.
class Entry < ApplicationRecord
  belongs_to :author, class_name: 'User'

  def published?
    published_at.present?
  end
end
