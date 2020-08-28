# frozen_string_literal: true

# ## Schema Information
#
# Table name: `attachments`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `uuid`             | `not null, primary key`
# **`attachable_type`**  | `string`           | `not null`
# **`attacher_type`**    | `string`           | `not null`
# **`rel`**              | `text`             | `not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`attachable_id`**    | `uuid`             | `not null`
# **`attacher_id`**      | `uuid`             | `not null`
#
# ### Indexes
#
# * `attachable_with_rel`:
#     * **`attachable_id`**
#     * **`attachable_type`**
#     * **`rel`**
# * `attacher_with_rel`:
#     * **`attacher_id`**
#     * **`attacher_type`**
#     * **`rel`**
# * `index_attachments_on_attachable_type_and_attachable_id`:
#     * **`attachable_type`**
#     * **`attachable_id`**
# * `index_attachments_on_attacher_type_and_attacher_id`:
#     * **`attacher_type`**
#     * **`attacher_id`**
#
class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, inverse_of: :attachments
  accepts_nested_attributes_for :attachable

  belongs_to :attacher, polymorphic: true

  validates :rel, presence: true

  def build_attachable(attrs)
    self.attachable = attachable_type.constantize.new(attrs)
  end
end
