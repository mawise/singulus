# frozen_string_literal: true

# Removes deprecated columns.
class Cleanup < ActiveRecord::Migration[6.0]
  def change
    remove_column :photos, :post_id, :uuid
    remove_column :photos, :duration, :interval
    remove_column :photos, :metadata, :hstore
    remove_column :photos, :attachable_type, :string
    remove_column :photos, :attachable_id, :uuid
    remove_column :photos, :attachable_rel, :text

    remove_column :posts, :syndications, :text, array: true
    remove_column :posts, :featured_id, :text, array: true
    remove_column :posts, :properties, :jsonb

    remove_column :users, :photo_id, :uuid
  end
end
