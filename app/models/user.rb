class User < ActiveRecord::Base
  acts_as_authentic
  belongs_to :account_type
  has_many :statuses

  # Attributes that should not be updated from a form or mass-assigned
  attr_protected :crypted_password, :password_salt, :perishable_token, :persistence_token, :confirmed_at, :admin

  has_attached_file :avatar, :styles => {
    :thumb => "100x100#"
  }


  def name
    @name ||= [first_name, last_name].join(' ')
  end

  def name=(_name)
    self.first_name, self.last_name = _name.split(' ')
  end

  def confirmed?
    confirmed_at
  end

  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    UserMailer.deliver_password_reset_instructions(self)  
  end


### Twitter Methods ###

  def twitter_username
    if twitter_authorized?
      @twitter_username ||= twitter_client.user({:count=>1}).first['user']['screen_name']
    end
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
  
  def self.find_by_smart_case_login_field(user_login)
    # login like an email address ?
    if user_login =~ Authlogic::Regex.email 
      first(:conditions => { :email => user_login })
    else
      first(:conditions => { :username => user_login })
    end
  end
  
  def self.find_by_login(login)
    find_by_smart_case_login_field(login)
  end
end
