source "https://rubygems.org"
ruby "2.0.0"

gem "jquery-rails"
gem "pg"
gem "rack-timeout"
gem "rails", "< 4.0"
gem "redis-rails"
gem "bootstrap-sass", "< 3.0.0"
gem "devise", ">= 2.2.3"
gem "devise_invitable"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem "state_machine"
gem "stripe", git: "https://github.com/stripe/stripe-ruby"
gem "memcachier"
gem "dalli"
gem "sidekiq"
gem "httparty"
gem "google_drive"
gem "active_attr", git: "https://github.com/haruska/active_attr.git"
gem "email_validator"

group :assets do
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">= 1.0.3"
end

group :development, :test do
  gem "capybara"
  gem "capybara-screenshot"
  gem "letter_opener"
  gem "letter_opener_web", "~> 1.2.0"
  gem "magic_lamp"
  gem "pry"
  gem "pry-nav"
  gem "rails-erd"
  gem "selenium-webdriver"
  #gem "teaspoon"
  #gem "vcr"
  gem "webmock"
  gem "database_cleaner", ">= 0.9.1"


  gem "newrelic_rpm"
  gem "thin", ">= 1.5.0"
  gem "rspec-rails", ">= 2.12.2"
  gem "factory_girl_rails", ">= 4.2.0"
  gem "faker"

  gem "quiet_assets", ">= 1.0.1"
  gem "figaro", ">= 0.5.3"
  gem "better_errors", ">= 0.6.0"
  gem "binding_of_caller", ">= 0.7.1"
  gem "rubocop"
end

group :test do
  gem "shoulda-matchers", require: false
  gem "email_spec", ">= 1.4.0"
  gem "cucumber-rails", ">= 1.3.0", require: false
  gem "launchy", ">= 2.2.0"
end

group :production do
  gem "unicorn"
end
