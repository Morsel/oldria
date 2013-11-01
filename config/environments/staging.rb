DEFAULT_HOST = 'staging.restaurantintelligenceagency.com'
Ria::Application.config do 
# Settings specified here will take precedence over those in config/environment.rb

ActionMailer::Base.delivery_method = :sendmail

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Using memcache as cache store
config.cache_store = :mem_cache_store

# See everything in the log (default is :info)
config.log_level = :debug

# config.gem 'mail_safe'

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "ny23sz9jy8gy38bw"
Braintree::Configuration.public_key = "n77z2dvd56jy4j9n"
Braintree::Configuration.private_key = "w8kw3smb2g2m6mds"

CLOUDMAIL_ID = 'd99c0e88ffd4ba590ae4'
CLOUDMAIL_DOMAIN = 'staging-mailbot.restaurantintelligenceagency.com'
# for verifying the emails came from cloudmailin
CLOUDMAIL_SECRET = '72fa425b1e5c89239639'.freeze

#ENV['MC_API_KEY'] = 'b992d9bf14db221d322b7add975b1c39-us2'
ENV['MAILCHIMP_API_KEY'] = 'e741c48b31e7dc460d7b7fa522741d6a-us5' #Nishant API key

DOMAIN_NAME = "restaurantintelligenceagency.com"
end