# frozen_string_literal: true

# Adds a type column to the posts table.
class AddTypeToPosts < ActiveRecord::Migration[6.0]
  def change
    change_table :posts, bulk: true do |t|
      t.text :type

      t.index :type
    end
  end
end
