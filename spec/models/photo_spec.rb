# frozen_string_literal: true

# ## Schema Information
#
# Table name: `photos`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `uuid`             | `not null, primary key`
# **`alt`**         | `text`             |
# **`duration`**    | `interval`         |
# **`file_data`**   | `jsonb`            |
# **`metadata`**    | `hstore`           | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`post_id`**     | `uuid`             |
#
# ### Indexes
#
# * `index_photos_on_metadata` (_using_ gin):
#     * **`metadata`**
# * `index_photos_on_post_id`:
#     * **`post_id`**
#
require 'rails_helper'

RSpec.describe Photo, type: :model do
  let(:fixtures_path) { Rails.root.join('spec/fixtures') }
  let(:file) { File.open(File.join(fixtures_path, 'photos/4.1.01.jpeg'), 'rb') }
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post, author: user) }

  it 'can attach a file' do
    photo = described_class.create(file: file, post: post)
    expect(photo.file.mime_type).to eq('image/jpeg')
  end
end
