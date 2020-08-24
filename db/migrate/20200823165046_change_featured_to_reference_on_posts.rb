# frozen_string_literal: true

# Changes featured from a text column to a reference on the posts table.
class ChangeFeaturedToReferenceOnPosts < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :featured, :text

    change_table :posts, bulk: true do |t|
      t.references :featured, type: :uuid

      t.foreign_key :photos, column: :featured_id
    end
  end
end
