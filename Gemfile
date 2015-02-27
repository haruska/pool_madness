source "https://rubygems.org"

gem "jquery-rails"
gem "pg"
gem "rails", "~> 4.2"
gem "devise"
gem "devise_invitable"
gem "cancancan", "~> 1.10"
gem "simple_form"
gem "stripe"
gem "dalli"
gem "sidekiq"
gem "httparty"
gem "google_drive"
gem "active_attr", git: "https://github.com/haruska/active_attr.git"
gem "email_validator"

gem "sass-rails", "~> 4.0.3"
gem "uglifier", ">=1.3.0"

gem "bourbon"
gem "bitters"
gem "neat"
gem "refills"
gem "font-awesome-rails"
gem "haml"

group :development, :test do
  gem "awesome_print"
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
  gem "spring"
  # gem "teaspoon"
  # gem "vcr"
  gem "webmock"
  gem "thin"
  gem "rspec-rails"

  gem "quiet_assets"
  gem "better_errors"
  gem "binding_of_caller"
  gem "rubocop"
end

group :development do
  gem "web-console", "~> 2.0"
end

group :test do
  gem "shoulda-matchers", require: false
  gem "fuubar"
  gem "simplecov", require: false
  gem "stripe-ruby-mock", "~> 2.0.1"
end

group :production, :staging do
  gem "rails_12factor"
  gem "unicorn"
  gem "newrelic_rpm"
end

group :staging do
  gem "recipient_interceptor"
end

group :test, :development, :staging do
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "faker"
end
