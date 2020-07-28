# frozen_string_literal: true

# An Entry consisting of unstructured, plain text.
class Note < Entry
  def permalink_url
    Rails.configuration.site_url + "/notes/#{short_uid}"
  end
end
