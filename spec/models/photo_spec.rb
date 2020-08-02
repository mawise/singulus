# frozen_string_literal: true

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
