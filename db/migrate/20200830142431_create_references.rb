# frozen_string_literal: true

# Creates the references table and removes the post reference from the citations table.
class CreateReferences < ActiveRecord::Migration[6.0]
  def change
    remove_column :citations, :post_id, :uuid
    remove_column :citations, :post_rel, :text

    create_table :references, id: :uuid do |t|
      t.references :citation, type: :uuid, index: true, foreign_key: true, null: false
      t.references :post, type: :uuid, index: true, foreign_key: true, null: false
      t.text :rel, null: false
      t.timestamps null: false

      t.index %i[citation_id rel]
      t.index %i[post_id rel]
      t.index %i[citation_id post_id rel], unique: true
    end
  end
end
