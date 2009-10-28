require 'rubygems'
require 'spork'

ENV["RAILS_ENV"] ||= 'test'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  require File.dirname(__FILE__) + "/../config/environment"
  require 'spec/autorun'
  require 'spec/rails'
  I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2 = true unless defined?(I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2)
  require 'remarkable_rails'
  require 'webrat'
  require 'webrat/rspec-rails'
  
  require "email_spec/helpers"
  require "email_spec/matchers"
  

  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

  Webrat.configure do |config|
    config.mode = :rails
  end

  Spec::Runner.configure do |config|
    config.use_instantiated_fixtures  = false
    config.use_transactional_fixtures = true
    config.include(EmailSpec::Helpers)
    config.include(EmailSpec::Matchers)
    config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
    config.mock_with :mocha
    include Webrat::Methods
  end
end

Spork.each_run do
end