# frozen_string_literal: true

# Common application helpers.
module ApplicationHelper
  def site_name
    Rails.configuration.site_name
  end

  def site_url
    Rails.configuration.site_url
  end
end
