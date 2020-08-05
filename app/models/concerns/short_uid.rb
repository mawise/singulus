# frozen_string_literal: true

# Automatically generates the value for a short_uid field.
module ShortUID
  extend ActiveSupport::Concern

  included do
    validates :short_uid, presence: true, uniqueness: { case_sensitive: true }

    before_validation :generate_short_uid, on: :create
  end

  def save_unique
    on_retry = proc do |_, _try, _, _|
      Rails.logger.info('Collison generating short_uid, trying again')
    end
    Retriable.retriable on: [ActiveRecord::RecordNotUnique], on_retry: on_retry do
      save
    end
  end

  protected

  def generate_short_uid
    self.short_uid = SecureRandom.uuid[0..5]
  end
end
