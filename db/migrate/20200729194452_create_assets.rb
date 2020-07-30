# frozen_string_literal: true

# Creates the assets table.
class CreateAssets < ActiveRecord::Migration[6.0]
  def change
    create_table :assets, id: :uuid do |t|
      t.references :post, type: :uuid, null: false
      t.text :alt
      t.interval :duration
      t.hstore :metadata, null: false, default: {}
      t.timestamps

      t.index :metadata, using: :gin
      t.foreign_key :posts, column: :post_id
    end
  end
end
