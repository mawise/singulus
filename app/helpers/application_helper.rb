# frozen_string_literal: true

# Common application helpers.
module ApplicationHelper
  def site_name
    Rails.configuration.x.site.name
  end

  def site_url
    Rails.configuration.x.site.url
  end

  def hub_host
    Rails.configuration.x.hub.host
  end

  def shortlinks_host
    Rails.configuration.x.shortlinks.host
  end
end
