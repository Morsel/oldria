# == Schema Information
# Schema version: 20100316193326
#
# Table name: users
#
#  id                    :integer         not null, primary key
#  username              :string(255)
#  email                 :string(255)
#  crypted_password      :string(255)
#  password_salt         :string(255)
#  perishable_token      :string(255)
#  persistence_token     :string(255)     not null
#  created_at            :datetime
#  updated_at            :datetime
#  confirmed_at          :datetime
#  last_request_at       :datetime
#  atoken                :string(255)
#  asecret               :string(255)
#  account_type_id       :integer
#  avatar_file_name      :string(255)
#  avatar_content_type   :string(255)
#  avatar_file_size      :integer
#  avatar_updated_at     :datetime
#  first_name            :string(255)
#  last_name             :string(255)
#  james_beard_region_id :integer
#  publication           :string(255)
#  role                  :string(255)
#

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
  has_many :admin_conversations, :through => :employments, :foreign_key => 'recipient_id'
  has_many :managed_restaurants, :class_name => "Restaurant", :foreign_key => "manager_id"

  has_many :employments, :foreign_key => "employee_id", :dependent => :destroy
  has_many :restaurants, :through => :employments

  has_many :discussion_seats, :dependent => :destroy
  has_many :discussions, :through => :discussion_seats

  has_many :posted_discussions, :class_name => "Discussion", :foreign_key => "poster_id"

  has_many :feed_subscriptions, :dependent => :destroy
  has_many :feeds, :through => :feed_subscriptions

  has_many :readings, :dependent => :destroy

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
  named_scope :by_last_name, :order => "LOWER(last_name) ASC"

### Preferences ###
  preference :hide_help_box, :default => false

### Roles ###
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

  def confirm!
    self.confirmed_at = Time.now
    self.save
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self)
  end

  def has_feeds?
    !feeds.blank?
  end

  def chosen_feeds(dashboard = false)
    return feeds.all(:limit => (dashboard ? 2 : nil)) if has_feeds?
    nil
  end

  def announcements
    Admin::Announcement.scoped(:order => "updated_at DESC").current
  end

  def pr_tips
    Admin::PrTip.scoped(:order => "updated_at DESC").current
  end

  def admin_discussions
    @admin_discussions ||= employments.map(&:admin_discussions).flatten
  end

  def current_admin_discussions
    admin_discussions.reject {|d| d.discussionable.scheduled_at > Time.now }
  end

  def unread_direct_messages
    direct_messages.unread_by(self)
  end

  def unread_pr_tips
    Admin::PrTip.current.find_unread_by( self )
  end

  def unread_announcements
    Admin::Announcement.current.find_unread_by( self )
  end

  def messages_from_ria
    @messages_from_ria ||= [ current_admin_discussions,
      admin_conversations.current.unread_by(self),
      unread_pr_tips,
      unread_announcements
    ].flatten.sort_by(&:updated_at).reverse
  end

  def all_messages
    @all_messages ||= [ admin_discussions,
      admin_conversations.current.all,
      Admin::Announcement.current.all,
      Admin::PrTip.current.all
    ].flatten.sort_by(&:updated_at).reverse
  end

  # For User.to_csv export
  def export_columns(format = nil)
    %w[username first_name last_name email]
  end

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
