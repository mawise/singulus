# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id           :uuid             not null, primary key
#  categories   :text             default([]), is an Array
#  content      :text
#  name         :text
#  properties   :jsonb            not null
#  published_at :datetime
#  short_uid    :text
#  slug         :text
#  summary      :text
#  url          :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :uuid             not null
#
# Indexes
#
#  index_posts_on_author_id     (author_id)
#  index_posts_on_categories    (categories) USING gin
#  index_posts_on_properties    (properties) USING gin
#  index_posts_on_published_at  (published_at)
#  index_posts_on_short_uid     (short_uid) UNIQUE
#  index_posts_on_slug          (slug) UNIQUE
#  index_posts_on_url           (url)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
# Represents episodic or datestamped content.
#
# @see http://microformats.org/wiki/h-entry.
class Post < ApplicationRecord
  include PostType

  searchkick

  belongs_to :author, class_name: 'User'

  has_many :shortlinks, as: :resource, dependent: :nullify

  has_many :photos, dependent: :nullify
  accepts_nested_attributes_for :photos, allow_destroy: true,
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
