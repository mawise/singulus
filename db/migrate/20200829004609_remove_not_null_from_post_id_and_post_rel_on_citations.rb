# frozen_string_literal: true

# Removes the null constraint on the post_id and post_rel columns on the citations table.
class RemoveNotNullFromPostIdAndPostRelOnCitations < ActiveRecord::Migration[6.0]
  def change
    change_column_null :citations, :post_id, true
    change_column_null :citations, :post_rel, true
  end
end
