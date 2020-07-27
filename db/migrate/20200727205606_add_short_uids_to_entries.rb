# frozen_string_literal: true

# Adds the short_uid column to the entries table.
class AddShortUidsToEntries < ActiveRecord::Migration[6.0]
  def change
    change_table :entries, id: :uuid do |t|
      t.text :short_uid
    end

    add_index :entries, :short_uid, unique: true
  end
end
