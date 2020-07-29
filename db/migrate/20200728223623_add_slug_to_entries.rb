# frozen_string_literal: true

# Adds a slug column to the entries table.
class AddSlugToEntries < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :slug, :text
    add_index :entries, :slug, unique: true
  end
end
