# frozen_string_literal: true

# A shortened URL that redirects to its target.
class Shortlink < ApplicationRecord
  include Doorkeeper::Models::Expirable

  LINK_REGEX = /\A[a-zA-Z0-9_\-]+\z/.freeze

  belongs_to :resource, polymorphic: true, optional: true

  validates :link, presence: true, uniqueness: { case_sensitive: true }, format: { with: LINK_REGEX }
  validates :target_url, presence: true, url: true

  before_validation :generate_short_uid, on: :create

  def tag_names
    tags.join(', ')
  end

  def tag_names=(val)
    self.tags = val.strip.gsub(/\s+/, ' ').split(',').map(&:strip)
  end

  def save_unique
    on_retry = proc do |_, _try, _, _|
      Rails.logger.info('Collison generating link, trying again')
    end
    Retriable.retriable on: [ActiveRecord::RecordNotUnique], on_retry: on_retry do
      save
    end
  end

  private

  def generate_short_uid
    self.link = SecureRandom.uuid[0..5] if link.blank?
  end
end
