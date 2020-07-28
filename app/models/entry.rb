# frozen_string_literal: true

# Represents episodic or datestamped content.
#
# @see http://microformats.org/wiki/h-entry.
class Entry < ApplicationRecord
  include EntryType

  belongs_to :author, class_name: 'User'

  validates :short_uid, presence: true, uniqueness: { case_sensitive: true }
  validates :slug, presence: true, uniqueness: { case_sensitive: true }

  before_validation :generate_short_uid, on: :create
  before_validation :generate_slug, on: :create

  def published?
    published_at.present?
  end

  def save_unique
    on_retry = proc do |_, _try, _, _|
      Rails.logger.info('Collison generating short_uid, trying again')
    end
    Retriable.retriable on: [ActiveRecord::RecordNotUnique], on_retry: on_retry do
      save
    end
  end

  private

  def generate_short_uid
    self.short_uid = SecureRandom.uuid[0..5]
  end

  def generate_slug
    return if slug.present?

    self.slug = if name.present?
                  name.parameterize
                else
                  short_uid
                end
  end
end
