# frozen_string_literal: true

require 'rails_helper'

describe DeleteWorker, type: :worker do
  let(:github) { instance_spy('Octokit::Client') }
  let(:github_repo) { 'some/repo' }
  let(:github_branch) { 'some-branch' }

  let(:user) { FactoryBot.create(:user) }
  let(:entry) { FactoryBot.create(:note, author: user) }

  let(:sha) { SecureRandom.hex }
  let(:contents) { double(sha: sha) } # rubocop:disable RSpec/VerifiedDoubles

  before do
    allow(Octokit::Client).to receive(:new) { github }
    allow(Rails.configuration.x.github).to receive(:branch) { github_branch }
    allow(Rails.configuration.x.github).to receive(:repo) { github_repo }
    allow(github).to receive(:contents).and_return(contents)
  end

  it 'deletes the entry content' do # rubocop:disable RSpec/ExampleLength
    described_class.new.perform(entry.id, entry.hugo_source_path)

    expect(github).to have_received(:delete_contents).with(
      github_repo,
      "content/notes/#{entry.id}.md",
      anything,
      sha,
      hash_including(branch: github_branch)
    )
  end
end
