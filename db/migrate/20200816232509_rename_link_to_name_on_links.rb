# frozen_string_literal: true

# Renames the link column to name on the links table.
class RenameLinkToNameOnLinks < ActiveRecord::Migration[6.0]
  def change
    rename_column :links, :link, :name
  end
end
