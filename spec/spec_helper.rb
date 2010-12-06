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

  Spec::Runner.configure do |config|
    config.use_instantiated_fixtures  = false
    config.use_transactional_fixtures = true
    config.include(EmailSpec::Helpers)
    config.include(EmailSpec::Matchers)
    config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
    config.mock_with :mocha
    config.ignore_backtrace_patterns(/spork/)
    config.after(:all) do
      if NetRecorder.recording?
        NetRecorder.cache!
      end
    end
    #include Webrat::Methods
  end

  module DisableFlashSweeping
    def sweep
    end
  end
end

Spork.each_run do
end

class UseLayout
  attr_reader :expected
  attr_reader :actual

  def initialize(expected)
    @expected = 'layouts/' + expected
  end

  def matches?(controller)
    if controller.is_a?(ActionController::Base)
      @actual = 'layouts/' + controller.class.read_inheritable_attribute(:layout)
    else
      @actual = controller.layout
    end
    @actual ||= "layouts/application"
    @actual == @expected
  end

  def description
    "Determines if a controller uses a layout"
  end

  def failure_message
    return "use_layout expected #{@expected.inspect}, got #{@actual.inspect}"
  end

 def negeative_failure_message
   return "use_layout expected #{@expected.inspect} not to equal #{@actual.inspect}"
  end
end

def use_layout(expected)
   UseLayout.new(expected)
end
