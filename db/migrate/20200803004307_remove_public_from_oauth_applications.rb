# frozen_string_literal: true

# Removes the public column from the oauth_applications table.
class RemovePublicFromOAuthApplications < ActiveRecord::Migration[6.0]
  def change
    remove_column :oauth_applications, :public, :boolean
  end
end
