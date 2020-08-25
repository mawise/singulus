# frozen_string_literal: true

# Adds the meta_description column to the posts table.
class AddMetaDescriptionToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :meta_description, :text
  end
end
