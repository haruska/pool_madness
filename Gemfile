source "https://rubygems.org"

gem "active_attr", git: "https://github.com/haruska/active_attr.git"
gem "bitters"
gem "bourbon"
gem "cancancan", "~> 1.10"
gem "dalli"
gem "devise"
gem "devise_invitable"
gem "email_validator"
gem "font-awesome-rails"
gem "google_drive"
gem "haml"
gem "httparty"
gem "jskit_rails"
gem "jquery-rails"
gem "lodash-rails"
gem "neat"
gem "pg"
gem "rails", "~> 4.2"
gem "refills"
gem "sass-rails", "~> 4.0.3"
gem "sidekiq"
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
  gem "thin"
end

group :development do
  gem "web-console", "~> 2.0"
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
  # 1.4.0 cleans schema_migrations, fixed in master
  gem "database_cleaner", github: "DatabaseCleaner/database_cleaner"

  gem "factory_girl_rails"
  gem "faker"
end
