# frozen_string_literal: true

# Creates a minimal entries table that will evolve as more support for h-entry is added.
class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries, id: :uuid do |t|
      t.references :author, type: :uuid, null: false
      t.text :type, null: false
      t.text :content
      t.datetime :published_at
      t.timestamps
    end

    add_index :entries, :published_at
    add_foreign_key :entries, :users, column: :author_id
  end
end
