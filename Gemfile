source "https://rubygems.org"

ruby "2.2.2"

gem "active_attr", github: "haruska/active_attr"
gem "binary_decision_tree"
gem "bitters"
gem "bourbon"
gem "cancancan", "~> 1.10"
gem "dalli"
gem "devise"
gem "devise_invitable"
gem "email_validator"
gem "espn_scraper", github: "haruska/espn-scraper"
gem "font-awesome-rails"
gem "google_drive"
gem "haml"
gem "hirefire-resource"
gem "httparty"
gem "jskit_rails"
gem "jquery-rails"
gem "lodash-rails"
gem "neat"
gem "pg"
gem "rails", "~> 4.2"
gem "redis"
gem "refills"
gem "sass-rails", "~> 4.0.3"
gem "sidekiq"
gem "sinatra", require: true
gem "simple_form"
gem "stripe"
gem "uglifier", ">=1.3.0"

group :development, :test do
  gem "awesome_print"
  gem "better_errors"
  gem "binding_of_caller"
  gem "capybara"
  gem "capybara-screenshot"
  gem "dotenv-rails"
  gem "letter_opener"
  gem "letter_opener_web", "~> 1.2.0"
  gem "magic_lamp"
  gem "pry"
  gem "pry-nav"
  gem "quiet_assets"
  gem "rails-erd"
  gem "rspec-rails"
  gem "rubocop"
  gem "selenium-webdriver"
  gem "spring"
end

group :development do
  gem "web-console", "~> 2.0"
  gem "bullet"
  gem "lol_dba"
end

group :test do
  gem "fuubar"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "stripe-ruby-mock", "~> 2.0.1"
  gem "webmock"
end

group :production, :staging do
  gem "newrelic_rpm"
  gem "rails_12factor"
  gem "unicorn"
end

group :staging do
  gem "recipient_interceptor"
end

group :test, :development, :staging do
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "faker"
end
