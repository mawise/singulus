# frozen_string_literal: true

# Adds columns to oauth_access_grants to enable PKCE in Doorkeeper.
class EnablePkce < ActiveRecord::Migration[6.0]
  def change
    change_table :oauth_access_grants, bulk: true do |t|
      t.text :code_challenge, null: true
      t.text :code_challenge_method, null: true
    end
  end
end
