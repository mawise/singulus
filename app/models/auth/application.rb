# frozen_string_literal: true

module Auth
  # Unified OAuth2/IndieAuth application.
  class Application < ApplicationRecord
    include Doorkeeper::Orm::ActiveRecord::Mixins::Application

    self.table_name = 'oauth_applications'
  end
end
