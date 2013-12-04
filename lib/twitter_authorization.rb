module TwitterAuthorization
  ### Twitter Methods ###
require 'tweetstream'

    def twitter_username
      return @twitter_username if defined?(@twitter_username)
      return @twitter_username = nil unless twitter_authorized?
      @twitter_username ||= twitter_client.user["screen_name"]
    rescue
      nil
    end

    def twitter_allowed?
      !(has_role? :media)
    end

    def twitter_authorized?
      !atoken.blank? && !asecret.blank?
    end

    def twitter_oauth
      @twitter_oauth ||= OAuth::Consumer.new(TWITTER_CONFIG['token'],
                                             TWITTER_CONFIG['secret'],
                                             :site => "https://api.twitter.com")
    end

    def twitter_client
      @twitter_client ||= begin
        TweetStream.configure do |config|
          config.consumer_key       = TWITTER_CONFIG['token']
          config.consumer_secret    = TWITTER_CONFIG['secret']
          config.oauth_token        = atoken
          config.oauth_token_secret = asecret
          config.auth_method        = :oauth
        end


        # Twitter.configure do |config|
        #   config.consumer_key = TWITTER_CONFIG['token']
        #   config.consumer_secret = TWITTER_CONFIG['secret']
        #   config.oauth_token = atoken
        #   config.oauth_token_secret = asecret
        # end
        Twitter::Client.new
      end
    end
  

  

end