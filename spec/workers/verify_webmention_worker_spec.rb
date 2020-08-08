# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VerifyWebmentionWorker, type: :worker do
  subject(:worker) { described_class.new }

  context 'with a valid source and target' do
    let(:source_url) { Faker::Internet.url }
    let(:source_body) do
      %(<div class="h-entry"><p class="e-content">I loved the post at #{target_post.permalink_url}!</p></div>)
    end
    let(:target_post) { FactoryBot.create(:post, author: user) }
    let(:user) { FactoryBot.create(:user) }
    let(:webmention) { FactoryBot.create(:webmention, source_url: source_url, target_url: target_post.permalink_url) }

    before do
      stub_request(:get, source_url).to_return(body: source_body)
    end

    it 'changes the status of the webmention to verified' do
      expect { worker.perform(webmention.id) }.to change { webmention.reload.status }.to('verified')
    end

    it 'sets the verified timestamp on the webmention' do
      expect { worker.perform(webmention.id) }.to change { webmention.reload.verified_at }.from(nil)
    end
  end
end
