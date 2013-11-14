# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ria::Application.initialize!


TWITTER_CONFIG = YAML.load(File.read(Rails.root + 'config' + 'twitter.yml'))[Rails.env]
BITLY_CONFIG = YAML.load(File.read(Rails.root + 'config' + 'bitly.yml'))[Rails.env]

Bitly.use_api_version_3
ActionMailer::Base.default :content_type => "text/html"


