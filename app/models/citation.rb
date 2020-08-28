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
# **`post_rel`**      | `text`             | `not null`
# **`publication`**   | `text`             |
# **`published_at`**  | `datetime`         |
# **`uid`**           | `text`             | `not null`
# **`urls`**          | `text`             | `is an Array`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`post_id`**       | `uuid`             | `not null`
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
class Citation < ApplicationRecord
  belongs_to :post, optional: true, touch: true

  def as_front_matter_json
    {
      author: author,
      content: content,
      name: name,
      publication: publication,
      url: urls,
      uid: uid,
      accessed: accessed_at.iso8601,
      published: published_at.iso8601
    }
  end
end
