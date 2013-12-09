require "#{Rails.root}/spec/factories"

require 'email_spec'
require 'email_spec/cucumber'
#require 'factory_girl/step_definitions'
require 'ap'

#include ActionView::Helpers::RecordIdentificationHelper

Capybara.javascript_driver = :webkit

FakeWeb.register_uri(:post, 'https://api.twitter.com/oauth/request_token', :body => 'oauth_token=fake&oauth_token_secret=fake')
tweet_file = File.new(File.dirname(__FILE__) + '/../../spec/fixtures/twitter_update.json').read
FakeWeb.register_uri(:get, 'https://api.twitter.com/1/statuses/home_timeline.json', :body => tweet_file)

FakeWeb.register_uri(:put, Regexp.new('http://s3.amazonaws.com/.*'), :body => "OK")
FakeWeb.register_uri(:head, Regexp.new('http://s3.amazonaws.com/.*'), :body => "OK")
FakeWeb.register_uri(:delete, Regexp.new('http://s3.amazonaws.com/.*'), :body => "OK")
