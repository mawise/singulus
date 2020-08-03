# frozen_string_literal: true

# Adds a profile_urls column to users.
class AddProfileUrlsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :profile_urls, :text, array: true, null: false, default: []
  end
end
