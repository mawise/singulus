# frozen_string_literal: true

# Adds a url column to the webmentions table.
class AddUrlToWebmentions < ActiveRecord::Migration[6.0]
  def change
    add_column :webmentions, :url, :text
  end
end
