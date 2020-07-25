# frozen_string_literal: true

# Creates the users table.
class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name, null: false, default: ''
      t.timestamps null: false

      # Device Database Authenticatable
      t.string :email, null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      # Devise Rememberable
      t.datetime :remember_created_at

      # Devise Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      # Devise Lockable
      t.integer  :failed_attempts, default: 0, null: false
      t.string   :unlock_token
      t.datetime :locked_at
    end

    add_index :users, :email, unique: true
    add_index :users, :unlock_token, unique: true
  end
end
