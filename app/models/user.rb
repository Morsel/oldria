class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_authorization_subject
  
  belongs_to :james_beard_region
  belongs_to :account_type
  has_many :statuses, :dependent => :destroy
  
  has_many :followings, :foreign_key => 'follower_id', :dependent => :destroy
  has_many :friends, :through => :followings
  has_many :inverse_followings, :class_name => "Following", :foreign_key => 'friend_id', :dependent => :destroy
  has_many :followers, :through => :inverse_followings, :source => :follower

  has_many :direct_messages, :foreign_key => "receiver_id", :dependent => :destroy
  has_many :sent_direct_messages, :class_name => "DirectMessage", :foreign_key => "sender_id", :dependent => :destroy

  has_many :media_requests, :foreign_key => 'sender_id'
  has_many :media_request_conversations, :foreign_key => "recipient_id"
  has_many :received_media_requests, :through => :media_request_conversations, :source => :media_request
  
  has_many :managed_restaurants, :class_name => "Restaurant", :foreign_key => "manager_id"
  
  has_and_belongs_to_many :roles

  # Attributes that should not be updated from a form or mass-assigned
  attr_protected :crypted_password, :password_salt, :perishable_token, :persistence_token, :confirmed_at, :admin=, :admin

  has_attached_file :avatar, 
                    :default_url => "/images/default_avatars/:style.png",
                    :styles => { :small => "100x100>", :thumb => "50x50#" }

  validates_exclusion_of :publication, 
                         :in => %w( freelance Freelance ), 
                         :message => "'{{value}}' is not allowed"
  
  
  def admin?
    @admin ||= has_role? :admin
  end
  alias :admin :admin?
  
  def admin=(bool)
    TRUE_VALUES.include?(bool) ? has_role!(:admin) : has_no_role!(:admin)
  end
  
  def following?(otheruser)
    friends.include?(otheruser)
  end

### Convenience methods for getting/setting first and last names ###
  def name
    @name ||= [first_name, last_name].compact.join(' ')
  end

  def name=(_name)
    name_parts = _name.split(' ')
    self.first_name = name_parts.shift
    self.last_name = name_parts.pop
  end
  
  def name_or_username
    name.blank? ? username : name
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
