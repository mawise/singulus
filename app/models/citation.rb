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
# **`publication`**   | `text`             |
# **`published_at`**  | `datetime`         |
# **`uid`**           | `text`             | `not null`
# **`urls`**          | `text`             | `is an Array`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_citations_on_name`:
#     * **`name`**
# * `index_citations_on_publication`:
#     * **`publication`**
# * `index_citations_on_uid` (_unique_):
#     * **`uid`**
# * `index_citations_on_urls` (_using_ gin):
#     * **`urls`**
#
class Citation < ApplicationRecord
  has_many :references, inverse_of: :citation, dependent: :destroy
  has_many :posts, through: :references, inverse_of: :citations

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
