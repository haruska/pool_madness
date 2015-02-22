source "https://rubygems.org"

gem "jquery-rails"
gem "pg"
gem "rails", "~> 4.0"
gem "bootstrap-sass", "< 3.0.0"
gem "devise"
gem "devise_invitable"
gem "cancancan", "~> 1.10"
gem "rolify"
gem "simple_form"
gem "state_machine"
gem "stripe"
gem "dalli"
gem "sidekiq"
gem "httparty"
gem "google_drive"
gem "active_attr", git: "https://github.com/haruska/active_attr.git"
gem "email_validator"

gem "sass-rails"
gem "uglifier"

group :development, :test do
  gem "capybara"
  gem "capybara-screenshot"
  gem "dotenv-rails"
  gem "letter_opener"
  gem "letter_opener_web", "~> 1.2.0"
  gem "magic_lamp"
  gem "pry"
  gem "pry-nav"
  gem "rails-erd"
  gem "selenium-webdriver"
  # gem "teaspoon"
  # gem "vcr"
  gem "webmock"

  gem "newrelic_rpm"
  gem "thin"
  gem "rspec-rails"

  gem "quiet_assets"
  gem "better_errors"
  gem "binding_of_caller"
  gem "rubocop"
end

group :test do
  gem "shoulda-matchers", require: false
  gem "launchy"
  gem "simplecov", require: false
  gem "stripe-ruby-mock", "~> 2.0.1"
end

group :production, :staging do
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
