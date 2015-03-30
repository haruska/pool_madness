PoolMadness::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # ActionMailer Config
  config.action_mailer.delivery_method = :test
  # change to true to allow email to be sent during development
  config.action_mailer.perform_deliveries = false

  # config.action_dispatch.rack_cache = {
  #    metastore:   "redis://localhost:6379/1/metastore",
  #    entitystore: "redis://localhost:6379/1/entitystore"
  # }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Expands the lines which load the assets
  config.assets.debug = true

  config.eager_load = false

  config.after_initialize do
    Bullet.enable = false
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
  end

  config.active_job.queue_adapter = :sidekiq
  # config.cache_store = :dalli_store
end
