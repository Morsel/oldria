# Settings specified here will take precedence over those in config/environment.rb
DEFAULT_HOST = 'spoonfeed.restaurantintelligenceagency.com'

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
config.cache_store = :mem_cache_store, "localhost:11211", { :namespace => "prod" }

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

Braintree::Configuration.environment = :production
Braintree::Configuration.merchant_id = "3fb27hjyr2pj4mkh"
Braintree::Configuration.public_key = "8946tj2vb98yf6xq"
Braintree::Configuration.private_key = "tkjvt5wph2m5qh33"

config.action_mailer.delivery_method = :emailthing

CLOUDMAIL_ID = '0df080edd37d5e209f5d'
CLOUDMAIL_DOMAIN = 'mailbot.restaurantintelligenceagency.com'
# for verifying the emails came from cloudmailin
CLOUDMAIL_SECRET = '781ff8e2b62535e0eee2'.freeze

ENV['MC_API_KEY'] = '50edf28727bd585ea1d143817bbb2cde-us2'