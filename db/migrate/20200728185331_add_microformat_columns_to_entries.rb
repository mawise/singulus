# frozen_string_literal: true

# Adds additional columns to the entries table that represent h-entry properties and removes STI.
class AddMicroformatColumnsToEntries < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'hstore'

    remove_column :entries, :type # rubocop:disable Rails/ReversibleMigration

    change_table :entries, id: :uuid do |t|
      t.text :name
      t.text :summary
      t.text :url
      t.text :categories, array: true, default: []
    end

    add_index :entries, :url
    add_index :entries, :categories, using: :gin
  end
end
