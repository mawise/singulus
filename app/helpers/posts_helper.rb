# frozen_string_literal: true

# Helpers for post views.
module PostsHelper
  def to_html_from_markdown(source)
    raw(Kramdown::Document.new(source, input: 'GFM').to_html) # rubocop:disable Rails/OutputSafety
  end
end
