class User < ActiveRecord::Base
  acts_as_authentic

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
  has_many :media_request_conversations, :through => :employments, :foreign_key => "recipient_id"

  has_many :managed_restaurants, :class_name => "Restaurant", :foreign_key => "manager_id"

  has_many :employments, :foreign_key => "employee_id"
  has_many :restaurants, :through => :employments

  has_many :discussion_seats
  has_many :discussions, :through => :discussion_seats

  has_many :posted_discussions, :class_name => "Discussion", :foreign_key => "poster_id"

  has_many :feed_subscriptions
  has_many :feeds, :through => :feed_subscriptions

  validates_presence_of :email

  attr_accessor :send_invitation, :agree_to_contract

  # Attributes that should not be updated from a form or mass-assigned
  attr_protected :crypted_password, :password_salt, :perishable_token, :persistence_token, :confirmed_at, :admin=, :admin

  has_attached_file :avatar,
                    :default_url => "/images/default_avatars/:style.png",
                    :styles => { :small => "100x100>", :thumb => "50x50#" }

  validates_exclusion_of :publication,
                         :in => %w( freelance Freelance ),
                         :message => "'{{value}}' is not allowed"

  validates_acceptance_of :agree_to_contract
  named_scope :for_autocomplete, :select => "first_name, last_name", :order => "last_name ASC", :limit => 15

  def admin?
    return @is_admin if defined?(@is_admin)
    @is_admin = has_role?(:admin)
  end
  alias :admin :admin?

  def media?
    return @is_media if defined?(@is_media)
    @is_media = has_role?(:media)
  end

  def admin=(bool)
    TRUE_VALUES.include?(bool) ? has_role!("admin") : has_no_role!(:admin)
  end

  def has_role?(_role)
    role == _role.to_s.downcase
  end

  def has_role!(role)
    update_attribute(:role, role.to_s)
  end

  def has_no_role!(role = nil)
    update_attribute(:role, nil)
  end

  def following?(otheruser)
    friends.include?(otheruser)
  end


  def allowed_subject_matters
    allsubjects = SubjectMatter.all
    admin? ? allsubjects : allsubjects.reject(&:admin_only?)
  end

  def coworkers
    coworker_ids = restaurants.map(&:employee_ids).flatten.uniq
    User.find(coworker_ids)
  end

### Convenience methods for getting/setting first and last names ###
  def name
    @name ||= [first_name, last_name].compact.join(' ')
  end

  def name=(_name)
    name_parts = _name.split(' ', 2)
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

  def has_feeds?
    !feeds.blank?
  end

  def chosen_feeds
    return feeds if has_feeds?
    nil
  end

  # For User.to_csv export
  def export_columns(format = nil)
    %w[username first_name last_name email]
  end

### Twitter Methods ###

  def twitter_username
    if twitter_authorized?
      @twitter_username ||= begin
        first_tweet = twitter_client.user({:count=>1})
        if first_tweet.kind_of?(Array)
          first_tweet.first['user']['screen_name']
        else
          nil
        end
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

  def self.find_by_name(_name)
    name_parts = _name.split(' ')
    find_by_first_name_and_last_name(name_parts.shift, name_parts.pop)
  end

  def self.find_all_by_name(_name)
    namearray = _name.split(" ")
    if namearray.length > 1
      first_name_begins_with(namearray.first).last_name_begins_with(namearray.last)
    else
      first_name_or_last_name_begins_with(namearray.first)
    end
  end

  def deliver_invitation_message!
    if @send_invitation
      @send_invitation = nil
      reset_perishable_token!
      logger.info( 'Delivering invitation email' )
      UserMailer.deliver_employee_invitation!(self)
    end
  end
end
