# Settings specified here will take precedence over those in config/environment.rb
# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Enable perform caching for testing dashboard caching
# This is temporary solution unless perform caching 
# will be set in runtime for specific tests
config.action_controller.perform_caching             = true

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

DEFAULT_HOST = 'localhost:3000'

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql
config.gem "rspec",             :lib => false, :version => '~>1.3.0'
config.gem "rspec-rails",       :lib => false, :version => '~>1.3.2'
config.gem "remarkable_rails",  :lib => false
config.gem "factory_girl",      :version => '~>1.2.3'
config.gem 'bmabey-email_spec', :lib => 'email_spec', :source => "http://gems.github.com"
config.gem "fakeweb",           :version => "1.3.0"
config.gem "netrecorder"
config.gem "mocha"
config.gem "spork",             :version => "~> 0.7.5"
config.gem "delorean"
config.gem "awesome_print",     :lib => "ap"
config.gem "accept_values_for", :version => "0.3.1"
config.gem "rails_best_practices", :version => "0.3.16"
# config.gem "metric_fu", :version => "1.5.1", :lib => "metric_fu"

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "ny23sz9jy8gy38bw" 
Braintree::Configuration.public_key = "n77z2dvd56jy4j9n" 
Braintree::Configuration.private_key = "w8kw3smb2g2m6mds"

CLOUDMAIL_DOMAIN = "testmailer"