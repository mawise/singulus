# frozen_string_literal: true

# ## Schema Information
#
# Table name: `references`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `uuid`             | `not null, primary key`
# **`rel`**          | `text`             | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
# **`citation_id`**  | `uuid`             | `not null`
# **`post_id`**      | `uuid`             | `not null`
#
# ### Indexes
#
# * `index_references_on_citation_id`:
#     * **`citation_id`**
# * `index_references_on_citation_id_and_post_id_and_rel` (_unique_):
#     * **`citation_id`**
#     * **`post_id`**
#     * **`rel`**
# * `index_references_on_citation_id_and_rel`:
#     * **`citation_id`**
#     * **`rel`**
# * `index_references_on_post_id`:
#     * **`post_id`**
# * `index_references_on_post_id_and_rel`:
#     * **`post_id`**
#     * **`rel`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`citation_id => citations.id`**
# * `fk_rails_...`:
#     * **`post_id => posts.id`**
#
class Reference < ApplicationRecord
  belongs_to :post, inverse_of: :references

  belongs_to :citation, inverse_of: :references
  accepts_nested_attributes_for :citation, allow_destroy: true

  validates :rel, presence: true
end
