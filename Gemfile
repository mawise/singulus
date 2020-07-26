# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Rails
gem 'rails', '~> 6.0'
gem 'puma', '~> 4.1'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '~> 1.4', require: false
gem 'tzinfo-data', '~> 1.2020.1'

# Frontend assets
gem 'sass-rails', '~> 6.0'
gem 'turbolinks', '~> 5.2'
gem 'webpacker', '~> 4.2'

# Data stores
gem 'pg', '~> 1.2'

# Security
gem 'devise', '~> 4.7'
gem 'doorkeeper', '~> 5.4'

# Git/GitHub
gem 'octokit', '~> 4.18'
gem 'rugged', '~> 1.0'

group :development, :test do
  gem 'byebug', '~> 11.1'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'faker', '~> 2.13'
  gem 'rspec-rails', '~> 2.7'
end

group :development do
  gem 'brakeman', '~> 4.8'
  gem 'listen', '~> 3.2'
  gem 'web-console', '~> 4.0'
  gem 'rubocop', '~> 0.88'
  gem 'rubocop-performance', '~> 1.7', require: false
  gem 'rubocop-rails', '~> 2.7', require: false
  gem 'rubocop-rspec', '~> 1.42', require: false
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0'
end
