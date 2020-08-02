# frozen_string_literal: true

# Renames the assets table to photos.
class RenameAssetsToPhotos < ActiveRecord::Migration[6.0]
  def change
    rename_table :assets, :photos
  end
end
