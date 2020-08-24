# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HugoPublishWorker, type: :worker do
  let(:github) { instance_spy('Octokit::Client') }
  let(:github_repo) { 'some/repo' }
  let(:github_branch) { 'some-branch' }

  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:note, :published, author: user) }

  before do
    allow(Octokit::Client).to receive(:new) { github }
    allow(Rails.configuration.x.github).to receive(:branch) { github_branch }
    allow(Rails.configuration.x.github).to receive(:repo) { github_repo }
  end

  describe 'with action of create' do
    it 'creates the post content' do # rubocop:disable RSpec/ExampleLength
      described_class.new.perform('create', post.id)

      expect(github).to have_received(:create_contents).with(
        github_repo,
        "content/notes/#{post.id}.md",
        anything,
        /#{Regexp.escape(post.content)}/,
        hash_including(branch: github_branch)
      )
    end
  end

  describe 'with action of update' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:sha) { SecureRandom.hex }
    let(:contents) { double(sha: sha) } # rubocop:disable RSpec/VerifiedDoubles

    before do
      allow(github).to receive(:contents).and_return(contents)
    end

    it 'updates the post content' do # rubocop:disable RSpec/ExampleLength
      described_class.new.perform('update', post.id)

      expect(github).to have_received(:update_contents).with(
        github_repo,
        "content/notes/#{post.id}.md",
        anything,
        sha,
        /#{Regexp.escape(post.content)}/,
        hash_including(branch: github_branch)
      )
    end
  end

  context 'when post has categories' do
    it 'adds the categories to the front matter' do # rubocop:disable RSpec/ExampleLength
      post.update(categories: %w[foo bar])
      described_class.new.perform('create', post.id)

      expect(github).to have_received(:create_contents).with(
        anything,
        anything,
        anything,
        /categories:\n- foo\n- bar/m,
        anything
      )
    end
  end

  context 'when post type is photo' do
    let(:post) { FactoryBot.create(:post_with_photos) }

    it 'adds the photo URL to the front matter' do # rubocop:disable RSpec/ExampleLength
      described_class.new.perform('create', post.id)

      expect(github).to have_received(:create_contents).with(
        anything,
        anything,
        anything,
        /url: #{Regexp.escape(post.photos.first.file_url)}/,
        anything
      )
    end

    it 'adds the photo alt text to the front matter' do # rubocop:disable RSpec/ExampleLength
      described_class.new.perform('create', post.id)

      expect(github).to have_received(:create_contents).with(
        anything,
        anything,
        anything,
        /alt: #{Regexp.escape(post.photos.first.alt)}/,
        anything
      )
    end
  end
end
