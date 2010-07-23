# == Schema Information
# Schema version: 20100715002740
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
#  facebook_id           :integer
#  facebook_access_token :string(255)
#

class User < ActiveRecord::Base
  acts_as_authentic
  include TwitterAuthorization
  include UserMessaging

  belongs_to :james_beard_region
  has_many :statuses, :dependent => :destroy

  has_many :followings, :foreign_key => 'follower_id', :dependent => :destroy
  has_many :friends, :through => :followings
  has_many :inverse_followings, :class_name => "Following", :foreign_key => 'friend_id', :dependent => :destroy
  has_many :followers, :through => :inverse_followings, :source => :follower

  has_many :direct_messages, :foreign_key => "receiver_id", :dependent => :destroy
  has_many :sent_direct_messages, :class_name => "DirectMessage", :foreign_key => "sender_id", :dependent => :destroy

  # Sent, not received media requests
  has_many :media_requests, :foreign_key => 'sender_id'

  has_many :admin_conversations, :through => :employments, :foreign_key => 'recipient_id'
  has_many :managed_restaurants, :class_name => "Restaurant", :foreign_key => "manager_id"

  has_many :employments, :foreign_key => "employee_id", :dependent => :destroy
  has_many :restaurants, :through => :employments
  has_many :manager_restaurants, :source => :restaurant, :through => :employments, :conditions => ["employments.omniscient = ?", true]

  has_many :discussion_seats, :dependent => :destroy
  has_many :discussions, :through => :discussion_seats

  has_many :posted_discussions, :class_name => "Discussion", :foreign_key => "poster_id"

  has_many :feed_subscriptions, :dependent => :destroy
  has_many :feeds, :through => :feed_subscriptions

  has_many :readings, :dependent => :destroy
  
  validates_presence_of :email

  attr_accessor :send_invitation, :agree_to_contract, :invitation_sender, :password_reset_required

  # Attributes that should not be updated from a form or mass-assigned
  attr_protected :crypted_password, :password_salt, :perishable_token, :persistence_token, :confirmed_at, :admin=, :admin

  has_attached_file :avatar,
                    :default_url => "/images/default_avatars/:style.png",
                    :styles => { :small => "100x100>", :thumb => "50x50#" }

  validates_exclusion_of :publication,
                         :in => %w( freelance Freelance ),
                         :message => "'{{value}}' is not allowed"
  validates_format_of :username,
                      :with => /^[a-zA-Z0-9\-\_ ]+$/,
                      :message => "'{{value}}' is not allowed. \
                      Usernames can only contain letters, numbers, and/or the '-' symbol."

  validates_acceptance_of :agree_to_contract

  named_scope :media, :conditions => {:role => 'media'}
  named_scope :admin, :conditions => {:role => 'admin'}

  named_scope :for_autocomplete, :select => "first_name, last_name", :order => "last_name ASC", :limit => 15
  named_scope :by_last_name, :order => "LOWER(last_name) ASC"

### Preferences ###
  preference :hide_help_box, :default => false
  preference :receive_email_notifications, :default => false

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
  alias :media :media?

  def admin=(bool)
    TRUE_VALUES.include?(bool) ? has_role!("admin") : has_no_role!(:admin)
  end

  def media=(bool)
    TRUE_VALUES.include?(bool) ? has_role!("media") : has_no_role!(:media)
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

  def restaurants_where_manager
    [managed_restaurants.all, manager_restaurants.all].compact.flatten.uniq
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
    confirmed_at.present?
  end
  alias :confirmed :confirmed?

  def confirmed=(value)
    self.confirmed_at = TRUE_VALUES.include?(value) ? Time.now : nil
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

  # For User.to_csv export
  def export_columns(format = nil)
    %w[username first_name last_name email]
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

  def self.receive_email_notifications
    Preference.all(:conditions => "value = 't' AND name = 'receive_email_notifications'").map(&:owner)
  end

  def deliver_invitation_message!
    if @send_invitation
      @send_invitation = nil
      reset_perishable_token!
      logger.info( "Delivering invitation email to #{email}" )
      UserMailer.deliver_employee_invitation!(self, invitation_sender)
    end
  end
  
  def connect_to_facebook_user(fb_id)
    update_attributes(:facebook_id => fb_id)
  end
  
  def facebook_authorized?
    !facebook_id.nil? and !facebook_access_token.nil?
  end
  
  def facebook_user
    if facebook_id and facebook_access_token
      @facebook_user ||= Mogli::User.new(:id => facebook_id, :client => Mogli::Client.new(facebook_access_token))
    end
  end
  
end
