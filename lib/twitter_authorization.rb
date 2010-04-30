module TwitterAuthorization
  ### Twitter Methods ###

    def twitter_username
      return @twitter_username if defined?(@twitter_username)
      return @twitter_username = nil unless twitter_authorized?
      @twitter_username ||= begin
        first_tweet = twitter_client.user({:count=>1})
        if first_tweet.respond_to?(:first) && first_tweet.first # Guards nil
          first_tweet.first['user']['screen_name']
        else
          nil
        end
      end
    end

    def twitter_allowed?
      !(has_role? :media)
    end

    def twitter_authorized?
      !atoken.blank? && !asecret.blank?
    end

    def twitter_oauth
      @twitter_oauth ||= TwitterOAuth::Client.new(
        :consumer_key =>    TWITTER_CONFIG['token'],
        :consumer_secret => TWITTER_CONFIG['secret']
      )
    end

    def twitter_client
      @twitter_client ||= begin
        TwitterOAuth::Client.new(
            :consumer_key =>    TWITTER_CONFIG['token'],
            :consumer_secret => TWITTER_CONFIG['secret'],
            :token =>           atoken,
            :secret =>          asecret
        )
      end
    end
    
end