# frozen_string_literal: true

# Creates the shortlinks table.
class CreateShortlinks < ActiveRecord::Migration[6.0]
  def change
    create_table :shortlinks, id: :uuid do |t|
      t.references :resource, type: :uuid, polymorphic: true

      t.text :link, null: false
      t.text :target_url, null: false
      t.text :title
      t.text :tags, array: true, null: false, default: []
      t.integer :expires_in
      t.timestamps

      t.index %i[resource_id resource_type]
      t.index :link, unique: true
      t.index :target_url
      t.index :tags, using: :gin
    end
  end
end
