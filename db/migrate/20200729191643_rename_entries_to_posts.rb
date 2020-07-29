# frozen_string_literal: true

# Renames the entries table to posts.
class RenameEntriesToPosts < ActiveRecord::Migration[6.0]
  def change
    rename_table :entries, :posts
  end
end
