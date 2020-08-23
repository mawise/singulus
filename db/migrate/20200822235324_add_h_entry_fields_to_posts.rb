# frozen_string_literal: true

# Adds columns for additional h-entry properties to the posts table.
class AddHEntryFieldsToPosts < ActiveRecord::Migration[6.0]
  def change
    change_table :posts, bulk: true do |t|
      t.jsonb :location
      t.integer :rsvp
      t.jsonb :in_reply_to
      t.jsonb :like_of
      t.jsonb :repost_of
      t.jsonb :bookmark_of
      t.text :syndications, array: true
      t.text :featured
      t.text :content_html

      t.index :location, using: :gin
      t.index :rsvp
      t.index :in_reply_to, using: :gin
      t.index :like_of, using: :gin
      t.index :repost_of, using: :gin
      t.index :bookmark_of, using: :gin
      t.index :syndications, using: :gin
    end
  end
end
