# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'will_paginate',         :version => "~>2.3.9"
  config.gem 'RedCloth',              :lib => 'redcloth'
  config.gem 'searchlogic',           :version => "~>2.5.8"
  config.gem 'authlogic',             :version => "2.1.6"
  config.gem 'addresslogic',          :version => "~>1.2.1"
  config.gem 'cancan',                :version => "~>1.0.1"
  config.gem 'paperclip',             :version => "2.3.3"
  config.gem 'aws-s3',                :lib => "aws/s3", :version => "0.6.2"
  config.gem 'faraday',               :version => "0.7.5"
  config.gem 'oauth',                 :version => "0.4.5"
  #config.gem 'twitter',               :version => "1.7.2"
  config.gem 'jackdempsey-acts_as_commentable', :lib => 'acts_as_commentable', :source => "http://gems.github.com"
  config.gem 'acts_as_list',          :version => "~>0.1.2"
  config.gem 'aasm',                  :version => "~>2.1.5"
  config.gem 'validation_reflection', :version => "~>0.3.5"
  config.gem 'formtastic',            :version => "~>0.9.7"
  config.gem 'tabletastic',           :version => "~>0.1.2" # Versions at or above 0.1.2, but below 0.2.0
  config.gem 'friendly_id',           :version => "~>2.2.7" # Versions at or above 2.2.7, but below 2.3.0
  config.gem 'loofah',                :version => "~>0.4.6"
  config.gem 'feedzirra',             :version => "0.0.24"
  config.gem 'preferences',           :version => "~>0.4.1"
  config.gem 'whenever',              :lib => false
  config.gem 'delayed_job',           :version => "~>1.8.4"
  config.gem "airbrake",              :version => "~> 3.1.1"
  config.gem 'backup',                :version => "~>2.3.1"
  config.gem 'newrelic_rpm',          :version => "~>3.1.1"
  config.gem "facebooker2",           :version => "~>0.0.4"
  config.gem 'subdomain-fu',          :version => "~>0.5.4"
  config.gem 'braintree',             :version => "2.22.0"
  config.gem 'ssl_requirement',       :version => "~>0.1.0"
  config.gem 'fastercsv'
  config.gem 'bitly',                 :version => "0.7.0"
  config.gem "bcrypt-ruby",           :version => "3.0.1", :lib => "bcrypt"
  config.gem "ar-octopus",            :version => "0.3.4", :lib => "octopus"
  config.gem "gibbon",                :version => "0.3.5"

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # Activate observers that should always be running
  config.active_record.observers = [:messaging_notification_observer, :site_activity_observer]

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Central Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  config.action_mailer.default_content_type = "text/html"
end

TWITTER_CONFIG = YAML.load(File.read(Rails.root + 'config' + 'twitter.yml'))[RAILS_ENV]
BITLY_CONFIG = YAML.load(File.read(Rails.root + 'config' + 'bitly.yml'))[RAILS_ENV]

Bitly.use_api_version_3

