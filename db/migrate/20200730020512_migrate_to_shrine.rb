# frozen_string_literal: true

# Removes ActiveStorage tables and adds `file_data` column to `assets` table.
class MigrateToShrine < ActiveRecord::Migration[6.0]
  def change
    drop_table :active_storage_attachments do
    end

    drop_table :active_storage_blobs do
    end

    add_column :assets, :file_data, :jsonb
  end
end
