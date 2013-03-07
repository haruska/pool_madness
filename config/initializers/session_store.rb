# Be sure to restart your server when you modify this file.

#PoolMadness::Application.config.session_store :cookie_store, key: '_pool_madness_session'

# config/initializers/session_store.rb
PoolMadness::Application.config.session_store :redis_store

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# PoolMadness::Application.config.session_store :active_record_store
