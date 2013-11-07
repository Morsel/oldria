
# Be sure to restart your server when you modify this file.

Ria::Application.config.session_store :cookie_store, key: '_ria_session'
Ria::Application.config.session_store :mem_cache_store
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Ria::Application.config.session_store :active_record_store
