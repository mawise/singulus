# frozen_string_literal: true

# Adds a JSON properties column to the posts table.
class AddPropertiesToPosts < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'citext'

    add_column :posts, :properties, :jsonb, null: false, default: '{}'

    add_index :posts, :properties, using: :gin
  end
end
