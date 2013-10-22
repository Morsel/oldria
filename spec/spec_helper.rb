require 'rubygems'
require 'spork'

ENV["Rails.env"] ||= 'test'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  require File.dirname(__FILE__) + "/../config/environment"
  require 'rspec/autorun'
  require 'rspec/rails'
  require 'rspec'
  I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2 = true unless defined?(I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2)
  require 'remarkable_rails'
  require 'webrat'
  require 'webrat/integrations/rspec-rails'

  require "email_spec/helpers"
  require "email_spec/matchers"
  require "support/braintree_spec_helper"

  require "authlogic/test_case"

  require "#{Rails.root}/spec/factories"

  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

  Webrat.configure do |config|
    config.mode = :rails
  end

  FakeWeb.allow_net_connect = false
  FakeWeb.register_uri(:head, Regexp.new('http://s3.amazonaws.com/.*'), :body => "OK")
  FakeWeb.register_uri(:delete, Regexp.new('http://s3.amazonaws.com/.*'), :body => "OK")
  FakeWeb.register_uri(:put, Regexp.new('http://s3.amazonaws.com/.*'), :body => "OK")

  def fake_admin_user
    @user = Factory.stub(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  def fake_normal_user
    @user = Factory.stub(:user)
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
    config.ignore_backtrace_patterns(/spork/)
  end

  module DisableFlashSweeping
    def sweep
    end
  end
end

Spork.each_run do
end
