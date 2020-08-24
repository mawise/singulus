# frozen_string_literal: true

module Dashboard
  # Helpers for post views.
  module PostsHelper
    def to_html_from_markdown(source)
      raw(Kramdown::Document.new(String(source), input: 'GFM').to_html) # rubocop:disable Rails/OutputSafety
    end
  end
end
