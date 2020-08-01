# frozen_string_literal: true

# Represents episodic or datestamped content.
#
# @see http://microformats.org/wiki/h-entry.
class Post < ApplicationRecord
  include PostType

  searchkick

  belongs_to :author, class_name: 'User'

  has_many :assets, dependent: :nullify
  accepts_nested_attributes_for :assets, allow_destroy: true,
                                         reject_if: proc { |a| a['file'].blank? && a['file_remote_url'].blank? }

  validates :short_uid, presence: true, uniqueness: { case_sensitive: true }
  validates :slug, presence: true, uniqueness: { case_sensitive: true }

  before_validation :generate_short_uid, on: :create
  before_validation :generate_slug, on: :create

  def category_names
    categories.join(', ')
  end

  def category_names=(val)
    self.categories = val.strip.gsub(/\s+/, ' ').split(',').map(&:strip)
  end

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
