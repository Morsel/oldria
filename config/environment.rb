# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'will_paginate', :source => "http://gemcutter.org"
  config.gem 'RedCloth', :lib => 'redcloth'
  config.gem 'searchlogic'
  config.gem 'authlogic'
  config.gem 'acl9', :source => "http://gemcutter.org"
  config.gem 'paperclip', :source => "http://gemcutter.org"
  config.gem 'moomerman-twitter_oauth', :lib => 'twitter_oauth', :source => "http://gems.github.com"
  config.gem 'jackdempsey-acts_as_commentable', :lib => 'acts_as_commentable', :source => "http://gems.github.com"
  config.gem 'aasm', :source => 'http://gemcutter.org'
  config.gem 'formtastic', :source => "http://gemcutter.org"
  config.gem 'validation_reflection', :source => "http://gemcutter.org"


  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Central Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

TWITTER_CONFIG = YAML.load(File.read(Rails.root + 'config' + 'twitter.yml'))[RAILS_ENV]

