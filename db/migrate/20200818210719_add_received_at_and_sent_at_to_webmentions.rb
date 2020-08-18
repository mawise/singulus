# frozen_string_literal: true

# Adds received_at and sent_at columns to the webmentions table.
class AddReceivedAtAndSentAtToWebmentions < ActiveRecord::Migration[6.0]
  def change
    change_table :webmentions, bulk: true do |t|
      t.datetime :received_at
      t.datetime :sent_at

      t.index :received_at
      t.index :sent_at
    end
  end
end
