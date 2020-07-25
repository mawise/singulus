# frozen_string_literal: true

# Base class for all other models.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
