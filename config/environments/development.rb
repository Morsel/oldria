# Settings specified here will take precedence over those in config/environment.rb
DEFAULT_HOST = 'localhost:3000'
# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
# config.action_mailer.delivery_method = :emailthing

config.gem "rails-footnotes", :version => '< 3.7.0'
config.gem 'mail_safe'
config.gem "awesome_print", :lib => "ap"
config.gem 'compass', :version => "~> 0.10.5"

require 'compass'
require 'compass/app_integration/rails'

# Turn off asset timestamp appends for development
ENV['RAILS_ASSET_ID'] = ''

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "ny23sz9jy8gy38bw" 
Braintree::Configuration.public_key = "n77z2dvd56jy4j9n" 
Braintree::Configuration.private_key = "w8kw3smb2g2m6mds"

CLOUDMAIL_DOMAIN = 'dev-mailbot.restaurantintelligenceagency.com'
