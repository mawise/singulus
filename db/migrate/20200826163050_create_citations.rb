# frozen_string_literal: true

# Creates the citations table.
class CreateCitations < ActiveRecord::Migration[6.0]
  def change
    create_table :citations, id: :uuid do |t|
      t.references :post, type: :uuid, index: true, foreign_key: true, null: false
      t.text :post_rel, null: false

      t.text :uid, null: false

      t.datetime :accessed_at
      t.jsonb :author
      t.text :content
      t.text :name
      t.text :publication
      t.text :urls, array: true
      t.datetime :published_at

      t.timestamps null: false

      t.index :name
      t.index :publication
      t.index :uid, unique: true
      t.index :urls, using: :gin

      t.index %i[post_id post_rel]
    end

    remove_column :posts, :bookmark_of, :jsonb
    remove_column :posts, :in_reply_to, :jsonb
    remove_column :posts, :like_of, :jsonb
    remove_column :posts, :repost_of, :jsonb
  end
end
