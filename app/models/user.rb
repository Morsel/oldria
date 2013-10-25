# == Schema Information
#
# Table name: users
#
#  id                        :integer         not null, primary key
#  username                  :string(255)
#  email                     :string(255)
#  crypted_password          :string(255)
#  password_salt             :string(255)
#  perishable_token          :string(255)
#  persistence_token         :string(255)     not null
#  created_at                :datetime
#  updated_at                :datetime
#  confirmed_at              :datetime
#  last_request_at           :datetime
#  atoken                    :string(255)
#  asecret                   :string(255)
#  avatar_file_name          :string(255)
#  avatar_content_type       :string(255)
#  avatar_file_size          :integer
#  avatar_updated_at         :datetime
#  first_name                :string(255)
#  last_name                 :string(255)
#  publication               :string(255)
#  role                      :string(255)
#  facebook_id               :string(255)
#  facebook_access_token     :string(255)
#  facebook_page_id          :string(255)
#  facebook_page_token       :string(255)
#  premium_account           :boolean
#  visible                   :boolean         default(TRUE)
#  national                  :boolean
#  mediafeed_visible         :boolean         default(TRUE)
#  notification_email        :string(255)
#  publish_profile           :boolean         default(TRUE)
#  facebook_token_expiration :datetime
#

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validates_format_of_login_field_options = { :with => /^[a-zA-Z0-9\-\_ ]+$/,
      :message => "'%{value}' is not allowed. Usernames can only contain letters, numbers, and/or the '-' symbol" }
    c.disable_perishable_token_maintenance = true
  end

  include TwitterAuthorization
  include FacebookPageConnect
  include UserMessaging


  include ActionView::Helpers::TextHelper  
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers
  default_url_options[:host] = DEFAULT_HOST

  
  has_many :trace_keywords, :as => :keywordable
  has_many :statuses, :dependent => :destroy
  has_many :followings, :foreign_key => 'follower_id', :dependent => :destroy
  has_many :friends, :through => :followings
  has_many :inverse_followings, :class_name => "Following", :foreign_key => 'friend_id', :dependent => :destroy
  has_many :followers, :through => :inverse_followings, :source => :follower

  has_many :direct_messages, :foreign_key => "receiver_id", :dependent => :destroy
  has_many :sent_direct_messages, :class_name => "DirectMessage", :foreign_key => "sender_id", :dependent => :destroy

  ## Sent, not received media requests
  has_many :media_requests, :foreign_key => 'sender_id'

  has_many :employments, :foreign_key => "employee_id", :dependent => :destroy, :conditions => "restaurant_id is not null"
  has_many :restaurants, :through => :employments
  has_many :managed_restaurants, :class_name => "Restaurant", :foreign_key => "manager_id"
  has_many :manager_restaurants, :source => :restaurant, :through => :employments, :conditions => ["employments.omniscient = ?", true]
  has_many :restaurant_roles, :through => :employments

  has_one :default_employment, :foreign_key => "employee_id", :dependent => :destroy

  ## For search
  has_many :all_employments, :foreign_key => "employee_id", :class_name => "Employment"
  has_many :all_restaurant_roles, :through => :all_employments, :source => "restaurant_role"

  has_many :discussion_seats, :dependent => :destroy
  has_many :discussions, :through => :discussion_seats

  has_many :posted_discussions, :class_name => "Discussion", :foreign_key => "poster_id"

  has_many :admin_conversations, :class_name => "Admin::Conversation", :foreign_key => 'recipient_id'

  has_many :solo_discussions, :through => :default_employment, :dependent => :destroy

  has_many :feed_subscriptions, :dependent => :destroy
  has_many :feeds, :through => :feed_subscriptions

  has_many :readings, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_one :profile, :dependent => :destroy
  has_many :profile_answers, :dependent => :destroy

  has_one :invitation, :foreign_key => "invitee_id"
  has_subscription
  include HasSubscription
  has_many :user_editors, :dependent => :destroy
  has_many :editors, :through => :user_editors

  has_one :featured_profile, :as => :feature

  has_many :restaurant_employee_requests ,:foreign_key=>"employee_id"
  has_many :requested_restaurants, :through => :restaurant_employee_requests ,:source=> :restaurant

  has_one :push_notification_user
  has_many :user_restaurant_visitors
  
  validates_presence_of :email
  
  #validates_presence_of :publication, :if => Proc.new { |user| user.role =="media" && user.id}
  #validates_presence_of :publication, :unless => Proc.new { |user| user.role !="media" }

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "is not a valid email address", :allow_blank => true

  has_and_belongs_to_many :metropolitan_areas
  has_many :media_newsletter_subscriptions, :dependent => :destroy, :foreign_key => "media_newsletter_subscriber_id"
  has_many :user_profile_subscribers, :dependent => :destroy, :foreign_key => "profile_subscriber_id"
  has_many :page_views, :as => :page_owner, :dependent => :destroy

  attr_accessor :send_invitation, :agree_to_contract, :invitation_sender, :password_reset_required
  attr_accessible :user_visitor_email_setting_attributes, :type, :solo_restaurant_name
  
  # Attributes that should not be updated from a form or mass-assigned
  attr_protected :crypted_password, :password_salt, :perishable_token, :persistence_token, :confirmed_at, :admin=, :admin

  accepts_nested_attributes_for :profile, :default_employment

  has_attached_file :avatar,
                    :default_url => "/images/default_avatars/:style.png",
                    :styles => { :large => "256x283#", :small => "100x100>", :thumb => "50x50#", :tiny => "20x20#" }

  validates_attachment_content_type :avatar,
      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png"],
      :message => "Please upload a valid image type: jpeg, gif, or png", :if => :avatar_file_name

  # validates_exclusion_of :publication,
  #                        :in => %w( freelance Freelance ),
  #                        :message => "'%{value}' is not allowed" #TODo this is remove as per client requirement ticketid:-51966367

  validates_acceptance_of :agree_to_contract

  validates_presence_of :facebook_page_token, :if => Proc.new { |user| user.facebook_page_id }
  validates_presence_of :facebook_page_id, :if => Proc.new { |user| user.facebook_page_token }

  after_create :deliver_invitation_message!, :if => Proc.new { |user| user.send_invitation }

  # Newsletter Subscriber
  has_one :newsletter_subscriber
  has_one :media_newsletter_setting
  # user visitor setting mail
  has_one :user_visitor_email_setting
  accepts_nested_attributes_for :media_newsletter_setting,:user_visitor_email_setting
  after_update :update_newsletter_subscriber, :if => Proc.new { |user| user.newsletter_subscriber.present? }

  scope :media, :conditions => { :role => 'media' }
  scope :not_media, :conditions => ["(role != ? OR role IS NULL)", "media"]
  scope :admin, :conditions => { :role => 'admin' }

  scope :for_autocomplete, :select => "first_name, last_name", :order => "last_name ASC", :limit => 15
  scope :by_last_name, :order => "LOWER(last_name) ASC"

  scope :active, :conditions => "last_request_at IS NOT NULL"
  scope :visible, :conditions => ['visible = ? AND (role != ? OR role IS NULL)', true, 'media']
  scope :with_published_profile, :conditions => ["publish_profile = ?", true]


  has_and_belongs_to_many  :newsfeed_metropolitan_areas ,:class_name =>"MetropolitanArea"
  accepts_nested_attributes_for :newsfeed_metropolitan_areas
### Preferences ###
  preference :hide_help_box, :default => false
  preference :receive_email_notifications, :default => true
  preference :publish_profile, :default => true # TODO - remove this after changes are on production

  belongs_to :newsfeed_writer
  belongs_to :digest_writer
  has_many :metropolitan_areas_writers
  
  has_many :regional_writers  
  has_many :newsfeed_promotion_types
  has_many :promotion_types,  :through => :newsfeed_promotion_types
  has_many :trace_searches, :as => :keywordable



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

  def has_chef_role?
    !(self.has_role?(:admin) || self.has_role?(:diner) || self.has_role?(:media))
  end 

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

  def self.find_premium(id)
    possibility = find_by_id(id)
    if possibility.premium_account then possibility else nil end
  end

  def following?(otheruser)
    friends.include?(otheruser)
  end

  ## Employment things
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

  def primary_employment
    self.employments.primary.first || self.employments.first || self.default_employment || self.employments
  end

  def nonprimary_employments
    employments - [primary_employment]
  end

  # do they have the setup needed for Behind the Line (profile questions)?
  def btl_enabled?
    primary_employment.present? && primary_employment.restaurant_role.present?
  end

  def restaurant_names
    if employments.blank?
      primary_employment.try(:solo_restaurant_name)
    elsif employments.count == 1
      primary_employment.restaurant.try(:name)
    else
      employments.all(:order => '"primary" DESC', :include => :restaurant).map{|e| e.restaurant.try(:name) }.to_sentence
    end
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

  def to_label
    name_or_username
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

  def completed_setup?
    self.profile.present? && self.primary_employment.present?
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
    find_all_by_name(_name).first
  end

  def self.find_all_by_name(_name)
    namearray = _name.split(" ")
    if namearray.length > 1
      search(:first_name_like => namearray.first).relation.search(:last_name_like=>namearray.last).relation
    else
      search(:first_name_or_last_name_like => namearray.first).relation
    end
  end

  def self.receive_email_notifications
    User.with_preferences(:receive_email_notifications => true)
  end

  def self.in_soapbox_directory
    active.visible.with_premium_account.with_published_profile.by_last_name
  end

  def self.in_spoonfeed_directory
    active.visible.by_last_name
  end

  def deliver_invitation_message!(reset_token = true)
    @send_invitation = nil
    reset_perishable_token! if reset_token
    logger.info( "Delivering invitation email to #{email}" )
    UserMailer.new_user_invitation!(self, invitation_sender).deliver
  end

  def email_for_content
    notification_email.present? ? notification_email : email
  end

  def self.build_media_from_registration(params)
    new_user = User.new(:first_name => params[:first_name],
                        :last_name => params[:last_name],
                        :email => params[:email],
                        :role => "media")
    new_user.username = [new_user.first_name, new_user.last_name].join("")
    new_user.password = new_user.password_confirmation = Authlogic::Random.friendly_token
    return new_user
  end

  # Facebook !!!

  def connect_to_facebook_user(fb_id, expiration)
    update_attributes(:facebook_id => fb_id, :facebook_token_expiration => expiration)
  end

  def facebook_authorized?
    facebook_id.present? and facebook_access_token.present?
  end

  def facebook_user
    if facebook_id and facebook_access_token
      @facebook_user ||= Mogli::User.new(:id => facebook_id, :client => Mogli::Client.new(facebook_access_token))
    end
  end

  def post_to_facebook(opts)
    self.facebook_user.feed_create(Mogli::Post.new(opts))
  rescue Mogli::Client::OAuthException, Mogli::Client::HTTPException
    Rails.logger.info("Unable to post to Facebook for #{name} on #{Time.now}")
  end

  # Behind the line

  def profile_questions
    self.primary_employment.present? ? ProfileQuestion.for_user(self) : []
  end

  def topics
    self.primary_employment.present? ? Topic.for_user(self) : []
  end

  def published_topics
    topics.select { |t| t.published?(self) }
  end

  def topics_without_travel
    self.primary_employment.present? ? Topic.for_user(self).without_travel : []
  end

  def published_topics_without_travel
    topics_without_travel.select { |t| t.published?(self) }
  end

  # Profile elements

  def cuisines
    profile.present? ? profile.cuisines : []
  end

  def specialties
    profile.present? ? profile.specialties : []
  end

  def james_beard_region
    profile.present? ? profile.james_beard_region : nil
  end

  def metropolitan_area
    profile.present? ? profile.metropolitan_area : nil
  end

  def phone_number
    if profile.present? then profile.cellnumber else nil end
  end

  def public_phone_number
    return nil if profile.blank? || !profile.display_cell_public?
    profile.cellnumber
  end

  def linkable_profile?
    self.publish_profile? && self.premium_account?
  end

  ## Subscriptions
  def braintree_contact
    self
  end

  def recently_upgraded?
    self.subscription.try(:start_date).try(:>, 1.week.ago.to_date)
  end

  # a string which can be used in the disposable part of the email to track and authenticate user
  def cloudmail_id(message)
    token = cloudmail_token(message)
    return "#{id}-#{token}-#{message.short_title}-#{message.id}"
  end
  
  # generates a one way hash used in the authentication for cloudmailin
  def cloudmail_token(message)
    Digest::SHA1.hexdigest("#{message.id}-#{id}-#{CLOUDMAIL_SEED}-#{email}")[0..8]
  end

  # checks the cloudmail_token is valid
  def validate_cloudmail_token!(token, message)
    unless token == cloudmail_token(message)
      throw 'invalid cloudmail token'
    end
  end

  # check if user is individual
  # or associated with a restaurants
  def individual?
    employments.blank?
  end

  # check if user associated with restaurants
  # has at least one filled role
  def has_restaurant_role?
    !self.employments.first(:conditions => 'restaurant_role_id IS NOT NULL').nil?
  end

  def self.extended_find(keyword)
    # when searchlogic will be updated, instead of all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # one can use id_not_in(users.map(&:id))

    # USER: first_name, last_name, role
    users = User.in_soapbox_directory.first_name_or_last_name_or_role_like(keyword)
    # USER->PROFILE: headline, summary, hometown, current_residence
    users += User.in_soapbox_directory.
      profile_headline_or_profile_summary_or_profile_hometown_or_profile_current_residence_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->METROPOLITAN AREA: name
    users += User.in_soapbox_directory.profile_metropolitan_area_name_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->CUISINES: name
    users += User.in_soapbox_directory.profile_cuisines_name_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->SPECIALTIES: name
    users += User.in_soapbox_directory.profile_specialties_name_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->RESAURANTS: name
    users += User.in_soapbox_directory.restaurants_name_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->AWARDS: name
    users += User.in_soapbox_directory.profile_awards_name_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->EMPLOYMENT->RESTAURANT_ROLE: name
    users += User.in_soapbox_directory.employments_restaurant_role_name_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->CULINARY_JOB: restaurant_name, title, chef_name, cuisine, notes
    users += User.in_soapbox_directory.profile_culinary_jobs_restaurant_name_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_culinary_jobs_title_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_culinary_jobs_chef_name_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_culinary_jobs_cuisine_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_culinary_jobs_notes_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->NONCULINARY_JOB: company, title, chef_name, cuisine, notes
    users += User.in_soapbox_directory.profile_nonculinary_jobs_company_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_nonculinary_jobs_title_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_nonculinary_jobs_responsibilities_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->ENROLLMENTS->SCHOOLS: name
    users += User.in_soapbox_directory.profile_schools_name_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->ENROLLMENTS: degree, focus, scholarships
    users += User.in_soapbox_directory.profile_enrollments_degree_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_enrollments_focus_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_enrollments_scholarships_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->NONCULINARY_ENROLLMENTS->SCHOOLS: name
    users += User.in_soapbox_directory.profile_nonculinary_schools_name_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->NONCULINARY_ENROLLMENTS: degree, field_of_study, achievements
    users += User.in_soapbox_directory.profile_nonculinary_enrollments_degree_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_nonculinary_enrollments_field_of_study_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_nonculinary_enrollments_achievements_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->COMPETITION: name
    users += User.in_soapbox_directory.profile_competitions_name_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->INTERNSHIPS: establishment, supervisor, comments
    users += User.in_soapbox_directory.profile_internships_establishment_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_internships_supervisor_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_internships_comments_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->STAGES: establishment, expert, comments
    users += User.in_soapbox_directory.profile_stages_establishment_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_stages_expert_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_stages_comments_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    # USER->PROFILE->APPRENTICESHIPS: establishment, supervisor, comments
    users += User.in_soapbox_directory.profile_apprenticeships_establishment_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_apprenticeships_supervisor_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])
    users += User.in_soapbox_directory.profile_apprenticeships_comments_like(keyword).
      all(:conditions => ["users.id NOT in (?)", [0] + users.map(&:id)])

    users
  end

  # conditions hash for mediafeed visible users only
  # Ex. Employment.all(User.mediafeed_only_condition)
  def self.mediafeed_only_condition
    options = { 
      :joins => [:restaurant, :employee],
      :conditions =>  [
        'users.mediafeed_visible = ? AND
        users.visible = ? AND 
        users.role != ? OR
        (users.role != ? OR users.role IS NULL)', 
        true, true, 'admin', 'media'
      ],
      :order => "LOWER(last_name) ASC" 
    }
  end

  # Is user has primary restaurant
  def primary_restaurant?
    primary_employment.present? && primary_employment.restaurant.present?
  end

  #get primary restaurant 
  def primary_restaurant
    if self.primary_restaurant?
      primary_employment.restaurant   
    end  
  end  

  def get_employee_requests
    RestaurantEmployeeRequest.find(:all,:conditions=>["restaurant_id in (?) and deleted_at is null ",self.restaurants.all(:select=>"restaurants.id")])
  end  

  def create_newsletter_subscriber
    return newsletter_subscriber if newsletter_subscriber.present?
    newsletter_subscriber = NewsletterSubscriber.create_from_user(self)
  end

  def update_newsletter_subscriber
    newsletter_subscriber.update_from_user(self)
  end
  def restaurant_newsletter_subscription restaurant    
    media_newsletter_subscriptions.find_by_restaurant_id(restaurant.id)
  end  

  def user_profile_subscribe user    
    user_profile_subscribers.find_by_user_id(user.id)
  end  

  #1 = National, 2 = Regional, 3 = Local
  def delete_other_writers    
    if newsfeed_writer_id == 1
      metropolitan_areas_writers.find(:all,:conditions=>"area_writer_type = 'NewsfeedWriter'").map(&:destroy)      
      regional_writers.find(:all,:conditions=>"regional_writer_type = 'NewsfeedWriter'").map(&:destroy)

    elsif  newsfeed_writer_id == 2       
      metropolitan_areas_writers.find(:all,:conditions=>"area_writer_type = 'NewsfeedWriter'").map(&:destroy) 
    elsif  newsfeed_writer_id == 3      
      regional_writers.find(:all,:conditions=>"regional_writer_type = 'NewsfeedWriter'").map(&:destroy)
    end 

    if digest_writer_id == 1
      metropolitan_areas_writers.find(:all,:conditions=>"area_writer_type = 'DigestWriter'").map(&:destroy)      
      regional_writers.find(:all,:conditions=>"regional_writer_type = 'DigestWriter'").map(&:destroy)
    elsif  digest_writer_id == 2
      
      metropolitan_areas_writers.find(:all,:conditions=>"area_writer_type = 'DigestWriter'").map(&:destroy)      
    elsif  digest_writer_id == 3
      
      regional_writers.find(:all,:conditions=>"regional_writer_type = 'DigestWriter'").map(&:destroy)
    end 

  end

  def update_media_newsletter_mailchimp

    if media?      
      mc = MailchimpConnector.new("RIA Newsfeed")              
      
      unless newsfeed_writer.blank?
        
        region_metro_areas = MetropolitanArea.find(:all,:conditions=>["state in (?)", newsfeed_writer.find_regional_writers(self).map(&:james_beard_region).map(&:description).join(",").gsub(/[\s]*/,"").split(",")]).map(&:id).uniq #If user has selected regions, getting metros of regions
        
        mc.client.list_subscribe(:id => mc.media_promotion_list_id, 
          :email_address => email,
          :merge_vars => {:FNAME=>first_name,
                          :LNAME=>last_name, 
                          :METROAREAS=>newsfeed_writer.find_metropolitan_areas_writers(self).map(&:metropolitan_area_id).join(",").to_s + truncate(region_metro_areas.join(","),:length => 255), 
                          :WRITERTYPE=>newsfeed_writer.name,           
                          :groupings => [
                              {:name=>"Regions",:groups=>newsfeed_writer.find_regional_writers(self).map(&:james_beard_region).map(&:name).join(",")},
                              { :name => "SubscriberType",:groups => "Newsfeed"},
                              {:name=>"Promotions",:groups=>promotion_types.map(&:name).join(",")}]           
          },:replace_interests => true,:update_existing=>true)
          
      end 
      digest_mailchimp_update       
    end  
  end  

  def get_digest_subscription
    @restaurants = []
    
    if digest_writer.name == "National Writer"
      @restaurants = Restaurant.all
    elsif digest_writer.name == "Regional Writer"
      @restaurants = digest_writer.find_regional_writers(self).map(&:james_beard_region).map(&:restaurants)
    else
      @restaurants = digest_writer.find_metropolitan_areas_writers(self).map(&:metropolitan_area).map(&:restaurants)

    end unless digest_writer.blank?

    @restaurants.flatten.compact.uniq

  end  

  def send_employee_claim_notification_mail
  
    User.find(:all,:conditions=>["role=?",'admin']).each do |user|
    user.restaurants.each do |restaurant|
        restaurant.employees.find(:all,:conditions=>["role != 'admin' || role IS NULL AND confirmed_at IS NULL"]).each do |employee|
          if employee.claim_count <= 3
            employee.claim_count+=1
            employee.publication= "NULL" if employee.publication.blank?
            employee.save!
            UserMailer.deliver_send_employee_claim_notification_mail(user,employee,restaurant)
          end
        end
      end
    end
  end

  def self.build_media_user(params)
    new_user = User.new(:first_name => params[:first_name],
                        :last_name => params[:last_name],
                        :email => params[:email],
                        :username =>params[:username],
                        :publication => params[:publication],
                        :password => params[:password],
                        :password_confirmation => params[:password],
                        :is_imported =>true,
                        :confirmed_at => Time.now,
                        :role => "media")
    return new_user
  end

  def digest_mailchimp_update

    #media_newsletter_subscriber.email email id will be replaced by this    
    signal = if media_newsletter_subscriptions.blank? && digest_writer.blank?
        "NO"
      else
        "YES"
      end 
    mc = MailchimpConnector.new("RIA Media") 
       
    mc.client.list_subscribe(:id => mc.media_promotion_list_id, 
        :email_address => email,
        :merge_vars => {:FNAME=>first_name,
                        :LNAME=>last_name,                        
                        :MYCHOICE=>signal,                                              
        },:replace_interests => true,:update_existing=>true)    
  end  

  def send_newsletter_to_media_subscribers subscriber
    
    if !subscriber.media_newsletter_setting.opt_out 
      begin
        mc = MailchimpConnector.new("RIA Media")
        campaign_id = \
        mc.client.campaign_create(:type => "regular",
                                  :options => { :list_id => mc.media_promotion_list_id,
                                                :subject => "RIA's Daily Dineline for #{Date.today.to_formatted_s(:long)}",
                                                :from_email => "hal@restaurantintelligenceagency.com",
                                                :to_name => "*|FNAME|*",
                                                :from_name => "Restaurant Intelligence Agency",
                                                :generate_text => true },
                                   :segment_opts => { :match => "all",
                                                      :conditions => [{ :field => "email",:op => "eq",:value => subscriber.email},{ :field => "MYCHOICE",:op => "eq",:value => 'YES'}]
                                                      },
                                  :content => { :url => media_user_newsletter_subscription_restaurants_url({:id=>subscriber.id}) })
        # send campaign
        mc.client.campaign_send_now(:cid => campaign_id)
      rescue Exception => e
        UserMailer.deliver_log_file("User : #{subscriber.name} Error: #{e.message}","Exception")
      end  
    end  
  end


end


