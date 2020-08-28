# frozen_string_literal: true

# Adds an attachable reference to the photos table.
class AddAttachableToPhotos < ActiveRecord::Migration[6.0]
  def change
    change_table :photos, bulk: true do |t|
      t.references :attachable, polymorphic: true, type: :uuid, index: true
      t.text :attachable_rel

      t.index %i[attachable_id attachable_type attachable_rel], name: :attachable
    end
  end
end
