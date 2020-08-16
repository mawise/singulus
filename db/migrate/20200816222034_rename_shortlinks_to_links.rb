# frozen_string_literal: true

# Renames the shortlinks table to links.
class RenameShortlinksToLinks < ActiveRecord::Migration[6.0]
  def change
    rename_table :shortlinks, :links
  end
end
