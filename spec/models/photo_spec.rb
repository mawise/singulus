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
# **`file_data`**   | `jsonb`            |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
require 'rails_helper'

RSpec.describe Photo, type: :model do
  let(:fixtures_path) { Rails.root.join('spec/fixtures') }
  let(:file) { File.open(File.join(fixtures_path, 'photos/4.1.01.jpeg'), 'rb') }

  it 'can attach a file' do
    photo = described_class.create(file: file)
    expect(photo.file.mime_type).to eq('image/jpeg')
  end
end
