

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.3", ">= 6.0.3.1"
# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
# Use Puma as the app server
gem "puma", "~> 4.3"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 4.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false
gem "haml-rails"
gem "redis", "4.1.4" # FIX https://stackoverflow.com/questions/62420602/setting-redis-configuration-options-in-sidekiq-container
gem "rollbar"
gem "sidekiq", "~> 6.0"
gem "whenever"
gem "will_paginate"
gem "will_paginate-bootstrap4"
# simple_form
gem "simple_form"
# for rake tasks
gem "ruby-progressbar"
gem "nokogiri", "~> 1.13.4"

gem "wikidata-client", "~> 0.0.10", require: "wikidata"
gem "newrelic_rpm"

group :test do
  gem "factory_bot_rails"
  gem "rspec-rails"

  gem "capybara"
  gem "launchy" # for capybara save_and_open_page
  gem "shoulda-matchers"
  gem "webdrivers", "~> 4.0"

  gem "mock_redis"
  gem "simplecov"
  gem "vcr"
  gem "webmock"
end

group :development, :test do
  gem "pry-nav"
  gem "pry-rails"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", "~> 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  gem "annotate"
  gem "better_errors"
  gem "binding_of_caller"
  gem "erb2haml", "~> 0.1.5"
  gem "haml_lint", require: false
  gem "rubocop", ">= 0.90", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end
