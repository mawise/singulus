# frozen_string_literal: true

# ## Schema Information
#
# Table name: `links`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`id`**             | `uuid`             | `not null, primary key`
# **`expires_in`**     | `integer`          |
# **`name`**           | `text`             | `not null`
# **`resource_type`**  | `string`           |
# **`tags`**           | `text`             | `default([]), not null, is an Array`
# **`target_url`**     | `text`             | `not null`
# **`title`**          | `text`             |
# **`created_at`**     | `datetime`         | `not null`
# **`updated_at`**     | `datetime`         | `not null`
# **`resource_id`**    | `uuid`             |
#
# ### Indexes
#
# * `index_links_on_name` (_unique_):
#     * **`name`**
# * `index_links_on_resource_id_and_resource_type`:
#     * **`resource_id`**
#     * **`resource_type`**
# * `index_links_on_resource_type_and_resource_id`:
#     * **`resource_type`**
#     * **`resource_id`**
# * `index_links_on_tags` (_using_ gin):
#     * **`tags`**
# * `index_links_on_target_url`:
#     * **`target_url`**
#
require 'rails_helper'

RSpec.describe Link, type: :model do
  it 'generates a unique link upon creation when none is present' do
    link = FactoryBot.create(:link)
    expect(link.name).not_to be_nil
  end

  it 'uses the provided link when present' do
    link = FactoryBot.create(:link, name: 'mylink')
    expect(link.name).to eq('mylink')
  end

  it 'converts tag names to tags on create' do
    link = FactoryBot.create(:link, tag_names: 'one, two, three')
    expect(link.tags).to eq(%w[one two three])
  end

  it 'converts tag names to tags on update' do
    link = FactoryBot.create(:link, tags: %w[one two three])
    expect { link.update(tag_names: 'four, five, six') }.to change(link, :tags).to eq(%w[four five six])
  end

  it 'returns tags as comma-separated tag names' do
    link = FactoryBot.create(:link, tags: %w[one two three])
    expect(link.tag_names).to eq('one, two, three')
  end
end
