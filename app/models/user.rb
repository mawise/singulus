# frozen_string_literal: true

# Represents a user who can authenticate to the application.
class User < ApplicationRecord
  devise :database_authenticatable, :lockable,
         :rememberable, :trackable, :validatable

  has_many :access_grants,
           inverse_of: :user,
           class_name: 'Auth::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :access_tokens,
           inverse_of: :user,
           class_name: 'Auth::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :posts, as: :author, dependent: :destroy
end
