# frozen_string_literal: true

# Represents episodic or datestamped content.
class Entry < ApplicationRecord
  belongs_to :author, class_name: 'User'

  validates :short_uid, presence: true, uniqueness: { case_sensitive: true }

  before_validation :generate_short_uid, on: :create

  def published?
    published_at.present?
  end

  private

  def generate_short_uid
    self.short_uid = SecureRandom.uuid[0..5]
  end
end
