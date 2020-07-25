# frozen_string_literal: true

# Enables the pgcrypto extension.
class EnablePgcrypto < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'
  end
end
