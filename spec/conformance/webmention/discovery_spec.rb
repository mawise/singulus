# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Webmention Implementation Report - Endpoint Discovery' do # rubocop:disable RSpec/DescribeClass
  def test_requests
    @test_requests ||= YAML.load_file(Rails.root.join('spec/fixtures/cassettes/webmention_rocks.yml'))['http_interactions'] # rubocop:disable Layout/LineLength
  end

  def user
    @user ||= FactoryBot.create(:user)
  end

  shared_examples 'discovery test' do |test_number, query, endpoint, target|
    subject(:webmention) do
      FactoryBot.create(:webmention, source: post, source_url: post.permalink_url, target_url: target_url)
    end

    let(:post) { FactoryBot.create(:note_post, content: target_url.to_s, author: user) }
    let(:target_url) { target || "https://webmention.rocks/test/#{test_number}" }
    let(:test_number) { test_number }
    let(:webmention_endpoint) { endpoint || "#{target_url}/webmention" }

    before do
      test_requests.filter { |r| r['request']['uri'].start_with?(target_url) }.each do |req|
        stub_request(:get, req['request']['uri'])
          .to_return(
            status: req['response']['status']['code'],
            headers: req['response']['headers'],
            body: req['response']['body']['string']
          )
      end

      if query
        stub_request(:post, webmention_endpoint)
          .with(query: query)
          .to_return(status: 201, headers: { 'Location': target_url })
      else
        stub_request(:post, webmention_endpoint)
          .to_return(status: 201, headers: { 'Location': target_url })
      end

      webmention.send_to_target!
    end

    it "posts to the correct webmention endpoint for https://webmention.rocks/test/#{test_number}" do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      if query
        expect(
          a_request(:post, webmention_endpoint)
          .with(query: query, body: { source: post.permalink_url, target: target_url })
        ).to have_been_made
      else
        expect(
          a_request(:post, webmention_endpoint).with(body: { source: post.permalink_url, target: target_url })
        ).to have_been_made
      end
    end
  end

  describe 'Discovery Test #1 - HTTP Link header, unquoted rel, relative URL' do
    include_examples 'discovery test', 1
  end

  describe 'Discovery Test #2 - HTTP Link header, unquoted rel, absolute URL' do
    include_examples 'discovery test', 2
  end

  describe 'Discovery Test #3 - HTML <link> tag, relative URL' do
    include_examples 'discovery test', 3
  end

  describe 'Discovery Test #4 - HTML <link> tag, absolute URL' do
    include_examples 'discovery test', 4
  end

  describe 'Discovery Test #5 - HTML <a> tag, relative URL' do
    include_examples 'discovery test', 5
  end

  describe 'Discovery Test #6 - HTML <a> tag, absolute URL' do
    include_examples 'discovery test', 6
  end

  describe 'Discovery Test #7 - HTTP Link header with strange casing' do
    include_examples 'discovery test', 7
  end

  describe 'Discovery Test #8 - HTTP Link header, quoted rel' do
    include_examples 'discovery test', 8
  end

  describe 'Discovery Test #9 - Multiple rel values on a <link> tag' do
    include_examples 'discovery test', 9
  end

  describe 'Discovery Test #10 - Multiple rel values on a Link header' do
    include_examples 'discovery test', 10
  end

  describe 'Discovery Test #11 - Multiple Webmention endpoints advertised: Link, <link>, <a>' do
    include_examples 'discovery test', 11
  end

  describe 'Discovery Test #12 - Checking for exact match of rel=webmention' do
    include_examples 'discovery test', 12
  end

  describe 'Discovery Test #13 - False endpoint inside an HTML comment' do
    include_examples 'discovery test', 13
  end

  describe 'Discovery Test #14 - False endpoint in escaped HTML' do
    include_examples 'discovery test', 14
  end

  describe 'Discovery Test #15 - Webmention href is an empty string' do
    include_examples 'discovery test', 15, nil, 'https://webmention.rocks/test/15'
  end

  describe 'Discovery Test #16 - Multiple Webmention endpoints advertised: <a>, <link>' do
    include_examples 'discovery test', 16
  end

  describe 'Discovery Test #17 - Multiple Webmention endpoints advertised: <link>, <a>' do
    include_examples 'discovery test', 17
  end

  describe 'Discovery Test #18 - Multiple HTTP Link headers' do
    include_examples 'discovery test', 18
  end

  describe 'Discovery Test #19 - Single HTTP Link header with multiple values' do
    include_examples 'discovery test', 19
  end

  describe 'Discovery Test #20 - Link tag with no href attribute' do
    include_examples 'discovery test', 20
  end

  describe 'Discovery Test #21 - Webmention endpoint has query string parameters' do
    include_examples 'discovery test', 21, { query: 'yes' }, 'https://webmention.rocks/test/21/webmention?query=yes'
  end

  describe 'Discovery Test #22 - Webmention endpoint is relative to the path' do
    include_examples 'discovery test', 22
  end

  describe 'Discovery Test #23 - Webmention target is a redirect and the endpoint is relative' do
    include_examples(
      'discovery test', 23, nil,
      'https://webmention.rocks/test/23/page/webmention-endpoint/RhS6WjhYqECZ8fYJz7Ao',
      'https://webmention.rocks/test/23/page'
    )
  end
end
