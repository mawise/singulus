# Adds status and status_info columns to webmentions.
class AddStatusAndStatusInfoToWebmentions < ActiveRecord::Migration[6.0]
  def change
    change_table :webmentions, type: :uuid do |t|
      t.text :status, null: false, default: 'pending'
      t.jsonb :status_info, null: false, default: {}

      t.index :status
    end
  end
end
