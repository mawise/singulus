# frozen_string_literal: true

# Creates the attachments table.
class CreateAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :attachments, id: :uuid do |t|
      t.belongs_to :attachable, polymorphic: true, type: :uuid, index: true, null: false
      t.belongs_to :attacher, polymorphic: true, type: :uuid, index: true, null: false
      t.text :rel, null: false
      t.timestamps null: false

      t.index %i[attachable_id attachable_type rel], name: :attachable_with_rel
      t.index %i[attacher_id attacher_type rel], name: :attacher_with_rel
    end
  end
end
