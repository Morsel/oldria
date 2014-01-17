require 'rubygems'
require 'spork'
require 'factory_girl'
require 'database_cleaner'
# ENV["RAILS_ENV"] ||= 'test'
ENV["Rails.env"] ||= 'test'
Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  require File.dirname(__FILE__) + "/../config/environment"
  require 'rspec/autorun'
  require 'rspec/rails' 
  # require 'rspec/core'
  require 'rspec'
  I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2 = true unless defined?(I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2)
  require 'remarkable_rails'
  require 'webrat'
  require 'webrat/integrations/rspec-rails'
  require 'email_spec' # add this line if you use spork
  # require 'email_spec/cucumber'
  require 'mocha'
  # require "mocha/setup"
  require "email_spec/helpers"
  require "email_spec/matchers"
  require "paperclip/matchers"
  require "braintree"
  # require "support/braintree_spec_helper"
  require 'fakeweb'
  require "authlogic/test_case"
  include Authlogic::TestCase
  require "#{Rails.root}/spec/factories"
  require 'rspec/rails/mocks'               if defined?(Rspec::Mocks)
  
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
  include Mail::Matchers
  Spec::Runner.configure do |config|
     config.include Paperclip::Shoulda::Matchers
   end

  Webrat.configure do |config|
    config.mode = :rails
  end

  FakeWeb.allow_net_connect = true
  FakeWeb.register_uri(:head, Regexp.new('http://s3.amazonaws.com/.*'), :body => "OK")
  FakeWeb.register_uri(:delete, Regexp.new('http://s3.amazonaws.com/.*'), :body => "OK")
  FakeWeb.register_uri(:put, Regexp.new('http://s3.amazonaws.com/.*'), :body => "OK")

  def fake_admin_user
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  def fake_normal_user
    @user = FactoryGirl.create(:user)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(false)
  end

  SAMPLES_PATH = File.expand_path(File.dirname(__FILE__) + "/email_samples") unless defined?(SAMPLES_PATH)

  def read_sample(path_fragment)
    File.read(File.join(SAMPLES_PATH, path_fragment))
  end

  RSpec.configure do |config|
    config.use_instantiated_fixtures  = false
    config.use_transactional_fixtures = true
    config.include(EmailSpec::Helpers)
    config.include(EmailSpec::Matchers)
    config.fixture_path = Rails.root + '/spec/fixtures/'
    config.mock_with :mocha
    # config.ignore_backtrace_patterns(/spork/)
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end

  module DisableFlashSweeping
    def sweep
    end
  end
end

Spork.each_run do
end
