# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ria_session',
  :secret      => '1283e584b520d6eb8fa4310856a4dedc46a960f3025b6b934b24faef34486d6bd1de52e3d2c6e4d51c20a6973ec5315f353188f771ff664ada6e072f2aa0ea83',
  :domain => DOMAIN_NAME
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
