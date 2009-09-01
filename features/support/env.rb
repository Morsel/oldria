# Suppress annoying error message
I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2 = true

# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'email_spec/cucumber'

Dir["#{Rails.root}/spec/factories/**/*.rb"].each {|f| require f}

# Comment out the next line if you don't want Cucumber Unicode support
require 'cucumber/formatter/unicode'

# Comment out the next line if you don't want transactions to
# open/roll back around each scenario
Cucumber::Rails.use_transactional_fixtures

# Comment out the next line if you want Rails' own error handling
# (e.g. rescue_action_in_public / rescue_responses / rescue_from)
Cucumber::Rails.bypass_rescue

require 'webrat'
require 'cucumber/webrat/table_locator' # Lets you do table.diff!(table_at('#my_table').to_a)

Webrat.configure do |config|
  config.mode = :rails
end

require 'cucumber/rails/rspec'
require 'webrat/core/matchers'

# Global Mocks and Stubs
@tweets = JSON.parse( File.new(File.dirname(__FILE__) + '/../../spec/fixtures/twitter_update.json').read )
TwitterOAuth::Client.any_instance.stubs(:friends_timeline).returns(@tweets)

User.any_instance.stubs(:twitter_username).returns("twitter_username")

Spec::Matchers.define :have_avatar do
  match { |user| user.avatar? }
end
