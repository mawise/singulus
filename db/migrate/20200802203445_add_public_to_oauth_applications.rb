# frozen_string_literal: true

# Adds a public column to the oauth_applications table.
class AddPublicToOAuthApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :oauth_applications, :public, :boolean, null: false, default: false

    add_index :oauth_applications, :public
  end
end
