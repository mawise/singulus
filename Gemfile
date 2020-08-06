# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Rails
gem 'actionmailer', '~> 6.0'
gem 'actionpack', '~> 6.0'
gem 'actionview', '~> 6.0'
gem 'activemodel', '~> 6.0'
gem 'activerecord', '~> 6.0'
gem 'activesupport', '~> 6.0'
gem 'bootsnap', '~> 1.4', require: false
gem 'puma', '~> 4.1'
gem 'railties', '~> 6.0'
gem 'tzinfo-data', '~> 1.2020.1'

# Instrumentation, logging, and monitoring
gem 'honeybadger', '~> 4.0'
gem 'newrelic_rpm', '~> 6.12'

# Frontend assets
gem 'sass-rails', '~> 6.0'
gem 'turbolinks', '~> 5.2'
gem 'webpacker', '~> 5.1'

# Data stores
gem 'pg', '~> 1.2'
gem 'redis', '~> 4.2'
gem 'redis-namespace', '~> 1.7'

# Background processing
gem 'sidekiq', '~> 6.1'
gem 'sidekiq-scheduler', '~> 3.0'
gem 'sidekiq-unique-jobs', '~> 7.0.0.beta22'

# Security
gem 'devise', '~> 4.7'
gem 'doorkeeper', '~> 5.4'
gem 'rack-attack', '~> 6.3'

# Cloud
gem 'aws-sdk-s3', '~> 1.75'

# File uploads
gem 'fastimage', '~> 2.2'
gem 'shrine', '~> 3.2'

# Git/GitHub
gem 'octokit', '~> 4.18'
gem 'rugged', '~> 1.0'

# Search
gem 'searchkick', '~> 4.4'

# Miscellaneous
gem 'dry-rails', '~> 0.2'
gem 'flutie', '~> 2.2'
gem 'interactor-rails', '~> 2.0'
gem 'kaminari', '~> 1.2'
gem 'kramdown', '~> 2.3'
gem 'kramdown-parser-gfm', '~> 1.1.0'
gem 'link-header-parser', '~> 2.0'
gem 'microformats', '~> 4.2'
gem 'oj', '~> 3.10'
gem 'retriable', '~> 3.1'
gem 'typhoeus', '~> 1.4'
gem 'validate_url', '~> 1.0'

group :development, :test do
  gem 'byebug', '~> 11.1'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'faker', '~> 2.13'
  gem 'pry', '~> 0.13'
  gem 'pry-byebug', '~> 3.9'
  gem 'pry-rails', '~> 0.3'
  gem 'rspec-rails', '~> 4.0'
end

group :development do
  gem 'annotate', '~> 3.1', require: false
  gem 'brakeman', '~> 4.9', require: false
  gem 'bullet', '~> 6.1'
  gem 'bundler-audit', '~> 0.7', require: false
  gem 'listen', '~> 3.2', require: false
  gem 'rubocop', '~> 0.88', require: false
  gem 'rubocop-faker', '~> 1.1', require: false
  gem 'rubocop-performance', '~> 1.7', require: false
  gem 'rubocop-rails', '~> 2.7', require: false
  gem 'rubocop-rspec', '~> 1.42', require: false
  gem 'solargraph', '~> 0.39', require: false
  gem 'spring', '~> 2.1', require: false
  gem 'spring-watcher-listen', '~> 2.0', require: false
  gem 'web-console', '~> 4.0'
end

group :test do
end
