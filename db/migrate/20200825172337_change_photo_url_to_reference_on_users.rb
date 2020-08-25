# frozen_string_literal: true

# Removes photo_url and adds photo_id to the users table.
class ChangePhotoUrlToReferenceOnUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :photo_url, :text

    change_table :users, bulk: true do |t|
      t.references :photo, type: :uuid, foreign_key: true
    end
  end
end
