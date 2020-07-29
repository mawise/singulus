# frozen_string_literal: true

require 'rails_helper'

describe PublishWorker, type: :worker do
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

  describe 'with action of update' do
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
end
