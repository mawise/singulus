# frozen_string_literal: true

# Renames the canonical_profile_url column to profile_url on the users table.
class RenameCanonicalProfileUrlToProfileUrlOnUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :canonical_profile_url, :profile_url
  end
end
