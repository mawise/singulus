# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                    :uuid             not null, primary key
#  canonical_profile_url :text
#  current_sign_in_at    :datetime
#  current_sign_in_ip    :inet
#  email                 :string           default(""), not null
#  encrypted_password    :string           default(""), not null
#  failed_attempts       :integer          default(0), not null
#  last_sign_in_at       :datetime
#  last_sign_in_ip       :inet
#  locked_at             :datetime
#  name                  :string           default(""), not null
#  profile_urls          :text             default([]), not null, is an Array
#  remember_created_at   :datetime
#  sign_in_count         :integer          default(0), not null
#  unlock_token          :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_users_on_canonical_profile_url  (canonical_profile_url)
#  index_users_on_email                  (email) UNIQUE
#  index_users_on_unlock_token           (unlock_token) UNIQUE
#
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
