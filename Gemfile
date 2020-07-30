# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Rails
gem 'bootsnap', '~> 1.4', require: false
gem 'jbuilder', '~> 2.7'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0'
gem 'tzinfo-data', '~> 1.2020.1'

# Frontend assets
gem 'sass-rails', '~> 6.0'
gem 'turbolinks', '~> 5.2'
gem 'webpacker', '~> 4.2'

# Data stores
gem 'pg', '~> 1.2'
gem 'redis', '~> 4.2'
gem 'redis-namespace', '~> 1.7'

# Background processing
gem 'sidekiq', '~> 6.1'
gem 'sidekiq-scheduler', '~> 3.0'

# Security
gem 'devise', '~> 4.7'
gem 'doorkeeper', '~> 5.4'

# Cloud
gem 'aws-sdk-s3', '~> 1.75'

# File uploads
gem 'fastimage', '~> 2.2'
gem 'shrine', '~> 3.0'

# Git/GitHub
gem 'octokit', '~> 4.18'
gem 'rugged', '~> 1.0'

# Miscellaneous
gem 'kaminari', '~> 1.2'
gem 'retriable', '~> 3.1'

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
  gem 'brakeman', '~> 4.8'
  gem 'listen', '~> 3.2'
  gem 'rubocop', '~> 0.88'
  gem 'rubocop-faker', '~> 1.1', require: false
  gem 'rubocop-performance', '~> 1.7', require: false
  gem 'rubocop-rails', '~> 2.7', require: false
  gem 'rubocop-rspec', '~> 1.42', require: false
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 4.0'
end

group :test do
  gem 'climate_control'
end
