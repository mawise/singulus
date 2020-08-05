# frozen_string_literal: true

# Creates the webmentions table.
class CreateWebmentions < ActiveRecord::Migration[6.0]
  def change
    create_table :webmentions, id: :uuid do |t|
      t.text :short_uid, null: false

      t.references :source, type: :uuid
      t.text :source_url, null: false
      t.jsonb :source_properties, null: false, default: {}

      t.references :target, type: :uuid
      t.text :target_url, null: false

      t.datetime :verified_at
      t.datetime :approved_at
      t.datetime :deleted_at

      t.timestamps

      t.index :source_properties, using: :gin
      t.index %i[source_id target_id], unique: true
      t.index %i[source_url target_url], unique: true
      t.index %i[source_url target_id], unique: true

      t.foreign_key :posts, column: :source_id
      t.foreign_key :posts, column: :target_id
    end
  end
end
