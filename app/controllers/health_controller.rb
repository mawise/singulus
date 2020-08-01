# frozen_string_literal: true

# Provides a dedicated healthcheck endpoint.
class HealthController < ApplicationController
  def show
    head :no_content
  end
end
