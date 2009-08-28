class User < ActiveRecord::Base
  acts_as_authentic
  belongs_to :account_type
  has_many :statuses

  # Attributes that should not be updated from a form or mass-assigned
  attr_protected :crypted_password, :password_salt, :perishable_token, :persistence_token, :confirmed_at, :admin
  
  def confirmed?
    confirmed_at
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    UserMailer.deliver_password_reset_instructions(self)  
  end


### Twitter Methods ###

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
