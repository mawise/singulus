# frozen_string_literal: true

# Removes the not null constraint on post_id from the assets table.
class RemovePostIdNullConstraintFromAssets < ActiveRecord::Migration[6.0]
  def change
    change_column_null :assets, :post_id, false

    remove_foreign_key :assets, :posts
  end
end
