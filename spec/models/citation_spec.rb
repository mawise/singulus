# frozen_string_literal: true

# ## Schema Information
#
# Table name: `citations`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `uuid`             | `not null, primary key`
# **`accessed_at`**   | `datetime`         |
# **`author`**        | `jsonb`            |
# **`content`**       | `text`             |
# **`name`**          | `text`             |
# **`post_rel`**      | `text`             |
# **`publication`**   | `text`             |
# **`published_at`**  | `datetime`         |
# **`uid`**           | `text`             | `not null`
# **`urls`**          | `text`             | `is an Array`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`post_id`**       | `uuid`             |
#
# ### Indexes
#
# * `index_citations_on_name`:
#     * **`name`**
# * `index_citations_on_post_id`:
#     * **`post_id`**
# * `index_citations_on_post_id_and_post_rel`:
#     * **`post_id`**
#     * **`post_rel`**
# * `index_citations_on_publication`:
#     * **`publication`**
# * `index_citations_on_uid` (_unique_):
#     * **`uid`**
# * `index_citations_on_urls` (_using_ gin):
#     * **`urls`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`post_id => posts.id`**
#
require 'rails_helper'

RSpec.describe Citation, type: :model do
  describe '#to_front_matter_json' do
    subject(:front_matter) { citation.as_front_matter_json }

    let(:citation) { FactoryBot.build(:citation, :bookmark) }

    it 'includes the name' do
      expect(front_matter).to include(name: citation.name)
    end

    it 'includes the content' do
      expect(front_matter).to include(content: citation.content)
    end

    it 'includes the UID' do
      expect(front_matter).to include(uid: citation.uid)
    end

    it 'includes the URLs' do
      expect(front_matter).to include(url: citation.urls)
    end

    it 'includes the access time formatted as ISO8601' do
      expect(front_matter).to include(accessed: citation.accessed_at.iso8601)
    end

    it 'includes the publish time formatted as ISO8601' do
      expect(front_matter).to include(published: citation.published_at.iso8601)
    end

    it 'includes the author' do
      expect(front_matter).to include(author: citation.author)
    end
  end
end
