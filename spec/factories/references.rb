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
FactoryBot.define do
  factory :reference do
    association :citation
    association :post

    trait :bookmark do
      rel { 'bookmark' }
    end

    trait :like do
      rel { 'like' }
    end

    trait :reply do
      rel { 'reply' }
    end

    trait :repost do
      rel { 'repost' }
    end
  end
end
