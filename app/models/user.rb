# frozen_string_literal: true

# Represents a user who can authenticate to the application.
class User < ApplicationRecord
  devise :database_authenticatable, :lockable,
         :rememberable, :trackable, :validatable

  has_many :access_grants, # rubocop:disable Rails/InverseOf
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :access_tokens, # rubocop:disable Rails/InverseOf
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all
end
