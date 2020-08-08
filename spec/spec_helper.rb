# frozen_string_literal: true

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 Coveralls::SimpleCov::Formatter
                                                               ])
SimpleCov.start('rails')
Rails.application.eager_load! # https://github.com/colszowka/simplecov#want-to-use-spring-with-simplecov

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?
  config.example_status_persistence_file_path = 'tmp/examples.txt'
  config.order = :random
  config.profile_examples = 10
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
