# frozen_string_literal: true

# Migration cleanup checkpoint.
class MigrationsCleanup < ActiveRecord::Migration[6.0]
  REQUIRED_VERSION = 20200829004609
  def up
    if ActiveRecord::Migrator.current_version < REQUIRED_VERSION
      raise StandardError, '`rails db:schema:load` must be run prior to `rails db:migrate`'
    end
  end
end
