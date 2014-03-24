source 'https://rubygems.org'
ruby '2.0.0'

gem 'rack-timeout'
gem 'rails', '< 4.0'
gem 'redis-rails'

gem 'google_drive'
gem 'active_attr', :git => 'https://github.com/haruska/active_attr.git'

group :development, :test do
  gem "thin", ">= 1.5.0"
end

gem 'pg'

group :production do
  gem 'unicorn'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "therubyracer", ">= 0.11.3", :require => "v8"
end

gem 'newrelic_rpm'
gem 'jquery-rails'
gem "rspec-rails", ">= 2.12.2", :group => [:development, :test]
gem "database_cleaner", ">= 0.9.1", :group => :test
gem "email_spec", ">= 1.4.0", :group => :test
gem "cucumber-rails", ">= 1.3.0", :group => :test, :require => false
gem "launchy", ">= 2.2.0", :group => :test
gem "capybara", ">= 2.0.2", :group => :test
gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]
gem "bootstrap-sass", "< 3.0.0"
gem "devise", ">= 2.2.3"
gem 'devise_invitable'
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem "quiet_assets", ">= 1.0.1", :group => :development
gem "figaro", ">= 0.5.3"
gem "better_errors", ">= 0.6.0", :group => :development
gem "binding_of_caller", ">= 0.7.1", :group => :development, :platforms => [:mri_19, :rbx]
gem "libv8", ">= 3.11.8"
gem "state_machine"
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'memcachier'
gem 'dalli'
gem 'sidekiq'
gem 'httparty'
