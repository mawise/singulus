# frozen_string_literal: true

# Base class for dashboard controllers.
class DashboardController < ApplicationController
  before_action :authenticate_user!
end
