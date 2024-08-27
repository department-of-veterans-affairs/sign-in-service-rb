# frozen_string_literal: true

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

source 'https://rubygems.org'

gem 'faraday'
gem 'jwt'
gem 'rake'

group :test do
  gem 'rack-test'
  gem 'rspec'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'rubocop', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
  gem 'vcr', require: false
  gem 'webmock', require: false
end

gemspec
