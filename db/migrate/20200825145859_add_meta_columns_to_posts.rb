# frozen_string_literal: true

# Adds metadata override columns for OpenGraph and Twitter to the posts table
class AddMetaColumnsToPosts < ActiveRecord::Migration[6.0]
  def change
    change_table :posts, bulk: true do |t|
      t.text :og_title
      t.text :og_url
      t.text :og_image
      t.text :og_type
      t.text :og_description
      t.text :og_locale
      t.text :twitter_card
      t.text :twitter_creator
      t.text :twitter_creator_id
      t.text :twitter_site
      t.text :twitter_site_id
      t.text :twitter_title
      t.text :twitter_description
      t.text :twitter_image
      t.text :twitter_image_alt
      t.text :twitter_player
      t.integer :twitter_player_width
      t.integer :twitter_player_height
      t.text :twitter_player_stream
    end

    change_table :users, bulk: true do |t|
      t.text :twitter_user_id
      t.text :twitter_username
    end
  end
end
