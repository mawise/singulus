# frozen_string_literal: true

# Adds a cnonical_profile_url column to the users table.
class AddCanonicalProfileUrlToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :canonical_profile_url, :text
    add_index :users, :canonical_profile_url
  end
end
