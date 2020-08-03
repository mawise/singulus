# frozen_string_literal: true

# Adds a url column to the oauth_applications table.
class AddUrlToOAuthApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :oauth_applications, :url, :text

    add_index :oauth_applications, :url, unique: true
  end
end
