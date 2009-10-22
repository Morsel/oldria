require 'email_spec/cucumber'


# Global Mocks and Stubs
User.any_instance.stubs(:twitter_username).returns("twitter_username")

Spec::Matchers.define :have_avatar do
  match { |user| user.avatar? }
end

@tweets = JSON.parse( File.new(File.dirname(__FILE__) + '/../../spec/fixtures/twitter_update.json').read )
TwitterOAuth::Client.any_instance.stubs(:friends_timeline).returns(@tweets)
