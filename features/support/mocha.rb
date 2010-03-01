require "mocha"
require "delorean"

World(Delorean)
World(Mocha::API)

Before do
  mocha_setup
end

After do
  begin
    mocha_verify
  ensure
    back_to_the_present
    mocha_teardown
  end
end

# Global Mocks and Stubs
User.any_instance.stubs(:twitter_username).returns("twitter_username")

Spec::Matchers.define :have_avatar do
  match { |user| user.avatar? }
end

@tweet_file = File.new(File.dirname(__FILE__) + '/../../spec/fixtures/twitter_update.json').read
@tweets = JSON.parse(@tweet_file)
TwitterOAuth::Client.any_instance.stubs(:friends_timeline).returns(@tweets)

FakeWeb.register_uri(:get, %r|http://twitter\.com/.+|, :body => @tweet_file)
