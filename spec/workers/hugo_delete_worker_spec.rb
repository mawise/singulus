# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HugoDeleteWorker, type: :worker do # rubocop:disable RSpec/MultipleMemoizedHelpers
  let(:github) { instance_spy('Octokit::Client') }
  let(:github_repo) { 'some/repo' }
  let(:github_branch) { 'some-branch' }

  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:note_post, author: user) }

  let(:sha) { SecureRandom.hex }
  let(:contents) { double(sha: sha) } # rubocop:disable RSpec/VerifiedDoubles

  before do
    allow(Octokit::Client).to receive(:new) { github }
    allow(Rails.configuration.x.github).to receive(:branch) { github_branch }
    allow(Rails.configuration.x.github).to receive(:repo) { github_repo }
    allow(github).to receive(:contents).and_return(contents)
  end

  it 'deletes the post content' do # rubocop:disable RSpec/ExampleLength
    described_class.new.perform(post.id, post.hugo_source_path)

    expect(github).to have_received(:delete_contents).with(
      github_repo,
      "content/notes/#{post.id}.md",
      anything,
      sha,
      hash_including(branch: github_branch)
    )
  end
end
