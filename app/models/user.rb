# frozen_string_literal: true

# Represents a user who can authenticate to the application.
class User < ApplicationRecord
  devise :database_authenticatable, :lockable,
         :rememberable, :trackable, :validatable
end
