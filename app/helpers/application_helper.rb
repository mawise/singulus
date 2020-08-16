# frozen_string_literal: true

# Common application helpers.
module ApplicationHelper
  def site_name
    Rails.configuration.x.site.name
  end

  def site_url
    Rails.configuration.x.site.url
  end

  def links_host
    Rails.configuration.x.links.host
  end
end
