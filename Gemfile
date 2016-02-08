source "https://rubygems.org"

ruby "2.2.4"

gem "active_attr", github: "haruska/active_attr"
gem "binary_decision_tree"
gem "bitters"
gem "bourbon"
gem "cancancan"
gem "dalli"
gem "devise"
gem "devise_invitable"
gem "email_validator"
gem "espn_scraper", github: "MikeSilvis/espn-scraper"
gem "font-awesome-rails"
gem "haml"
gem "httparty"
gem "rails_jskit", "=5.1.0" # 5.1.3 breaks binding this to functions
gem "jquery-rails"
gem "lodash-rails", "~> 3.10" # support of jskit
gem "neat"
gem "pg"
gem "rails", "~> 4.2"
gem "redis"
gem "refills"
gem "sass-rails"
gem "sidekiq"
gem "sinatra", require: true
gem "simple_form"
gem "stripe"
gem "uglifier"

group :staging, :development, :test do
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "faker"
end

group :development, :test do
  gem "awesome_print"
  gem "better_errors"
  gem "binding_of_caller"
  gem "byebug"
  gem "capybara"
  gem "capybara-screenshot"
  gem "dotenv-rails"
  gem "letter_opener"
  gem "letter_opener_web"
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

group :production, :staging do
  gem "newrelic_rpm"
  gem "rails_12factor"
  gem "unicorn"
end

group :production do
  gem "hirefire-resource"
end

group :staging do
  gem "recipient_interceptor"
end

group :development do
  gem "bullet"
  gem "lol_dba"
  gem "web-console"
end

group :test do
  gem "fuubar"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "stripe-ruby-mock"
  gem "webmock"
end







