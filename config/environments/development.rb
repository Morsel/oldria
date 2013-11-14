Ria::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
config.consider_all_requests_local = true
  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Settings specified here will take precedence over those in config/environment.rb
DEFAULT_HOST = 'localhost.elevatedrails.com:3000'
# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
# config.action_view.debug_rjs = true

# config.gem "rails-footnotes", :version => '< 3.7.0'
# config.gem 'mail_safe'
# config.gem "awesome_print", :lib => "ap"
# config.gem 'compass', :version => "~> 0.10.5"

require 'compass'
require 'compass/app_integration/rails'

# Turn off asset timestamp appends for development
ENV['RAILS_ASSET_ID'] = ''

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "ny23sz9jy8gy38bw" 
Braintree::Configuration.public_key = "n77z2dvd56jy4j9n" 
Braintree::Configuration.private_key = "w8kw3smb2g2m6mds"

CLOUDMAIL_DOMAIN = 'dev-mailbot.restaurantintelligenceagency.com'

ENV['MAILCHIMP_API_KEY'] = "e741c48b31e7dc460d7b7fa522741d6a-us5"#'1eb9e1ef0870c8caf6651ee2cf1232c0-us5'
DOMAIN_NAME = "hq.smack.st"
end
