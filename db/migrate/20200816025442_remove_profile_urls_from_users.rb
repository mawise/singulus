# frozen_string_literal: true

# Removes the profile_urls column from the users table.
class RemoveProfileUrlsFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :profile_urls, :text, array: true
  end
end
