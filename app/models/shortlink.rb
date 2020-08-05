# frozen_string_literal: true

# == Schema Information
#
# Table name: shortlinks
#
#  id            :uuid             not null, primary key
#  expires_in    :integer
#  link          :text             not null
#  resource_type :string
#  tags          :text             default([]), not null, is an Array
#  target_url    :text             not null
#  title         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :uuid
#
# Indexes
#
#  index_shortlinks_on_link                           (link) UNIQUE
#  index_shortlinks_on_resource_id_and_resource_type  (resource_id,resource_type)
#  index_shortlinks_on_resource_type_and_resource_id  (resource_type,resource_id)
#  index_shortlinks_on_tags                           (tags) USING gin
#  index_shortlinks_on_target_url                     (target_url)
#
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
