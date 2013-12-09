# == Schema Information
#
# Table name: restaurants
#
#  id                         :integer         not null, primary key
#  name                       :string(255)
#  street1                    :string(255)
#  street2                    :string(255)
#  city                       :string(255)
#  state                      :string(255)
#  zip                        :string(255)
#  country                    :string(255)
#  facts                      :text
#  created_at                 :datetime
#  updated_at                 :datetime
#  manager_id                 :integer
#  metropolitan_area_id       :integer
#  james_beard_region_id      :integer
#  cuisine_id                 :integer
#  deleted_at                 :datetime
#  description                :text
#  phone_number               :string(255)
#  website                    :string(255)
#  twitter_handle             :string(255)
#  facebook_page_url          :string(255)
#  hours                      :string(255)
#  media_contact_id           :integer
#  management_company_name    :string(255)
#  management_company_website :string(255)
#  logo_id                    :integer
#  primary_photo_id           :integer
#  opening_date               :date
#  premium_account            :boolean
#  sort_name                  :string(255)
#  facebook_page_id           :string(255)
#  facebook_page_token        :string(255)
#  atoken                     :string(255)
#  asecret                    :string(255)
#  is_activated               :boolean         default(FALSE)
#  newsletter_frequency       :string(255)
#

require 'chronic'

class Restaurant < ActiveRecord::Base
  apply_addresslogic
  has_subscription
  include HasSubscription
  include FacebookPageConnect
  include TwitterAuthorization

  include ActionView::Helpers::TextHelper  
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers
  default_url_options[:host] = DEFAULT_HOST

  default_scope :conditions => {:deleted_at => nil }, :order => "#{table_name}.sort_name"

  # primary account manager
  belongs_to :manager, :class_name => "User", :foreign_key => 'manager_id'
  belongs_to :media_contact, :class_name => "User", :foreign_key => 'media_contact_id'

  belongs_to :metropolitan_area
  belongs_to :james_beard_region
  belongs_to :cuisine

  has_many :employments, :dependent => :destroy
  has_many :employees, :through => :employments

  # all account managers should be omniscient
  has_many :managers,
           :through => :employments,
           :source => :employee,
           :conditions => { :employments => { :omniscient => true }}

  has_many :media_request_discussions, :dependent => :destroy
  has_many :media_requests, :through => :media_request_discussions
  has_many :admin_discussions, :dependent => :destroy
  has_many :holiday_discussions, :dependent => :destroy
  has_many :holidays, :through => :holiday_discussions
  has_many :trend_questions, :through => :admin_discussions,
           :source => :discussionable, :source_type => 'TrendQuestion'
  has_many :content_requests, :through => :admin_discussions,
           :source => :discussionable, :source_type => 'ContentRequest'

  has_many :promotions, :dependent => :destroy
  has_many :menu_items, :dependent => :destroy
  has_many :events
  has_many :menus
  has_many :accolades, :as => :accoladable
  has_many :a_la_minute_answers, :as => :responder, :dependent => :destroy
  has_many :press_releases
  has_many :restaurant_answers

  has_many :newsletter_subscriptions, :dependent => :destroy
  has_many :newsletter_subscribers, :through => :newsletter_subscriptions
  has_many :restaurant_newsletters
  has_many :social_posts

  has_many :restaurant_feature_items, :dependent => :destroy
  has_many :restaurant_features, :through => :restaurant_feature_items,
      :include => {:restaurant_feature_category => :restaurant_feature_page}

  has_many :photos, :class_name => "Photo", :as => :attachable, :order => "position ASC", :dependent => :destroy,
    :after_add => :reset_primary_photo_on_add, :after_remove => :reset_primary_photo_on_remove
  belongs_to :primary_photo, :class_name => "Photo", :dependent => :destroy
  belongs_to :logo, :class_name => "Image", :dependent => :destroy

  has_one :featured_profile, :as => :feature

  has_many :restaurant_employee_requests
  has_many :requested_employees, :through => :restaurant_employee_requests ,:source =>:employee

  has_many :user_restaurant_visitors
  has_many :restaurant_visitors ,:through => :user_restaurant_visitors ,:source => :user
  
  accepts_nested_attributes_for :logo ,:photos

  validates_presence_of :name, :street1, :city, :state, :zip, :phone_number,
      :metropolitan_area, :website, :media_contact, :cuisine, :opening_date, :manager,:james_beard_region

  validates_format_of :management_company_website,
      :with => URI::regexp(%w(http https)),
      :message => "needs to be a valid URL that starts with http://",
      :allow_blank => true

  validates_format_of :facebook_page_url,
      :with => %r{^https*://www\.facebook\.com(.*)},
      :allow_blank => true,
      :message => "Facebook page must start with http://www.facebook.com"

  validates_inclusion_of :newsletter_frequency, :in => ["weekly", "biweekly", "monthly"]
  validates_inclusion_of :newsletter_frequency_day, :in => ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

  has_one :subscription, :as => :subscriber
  
  has_one :newsletter_setting 
  accepts_nested_attributes_for :newsletter_setting

  has_one  :visitor_email_setting
  before_validation :add_manager_as_employee, :on => :create
  # after_validation_on_create :add_manager_as_employee
  after_create :update_manager
  before_destroy :migrate_employees_to_default_employment

  has_one :fact_sheet, :class_name => "RestaurantFactSheet"
  after_create :add_fact_sheet
  after_create :add_api_token

  preference :publish_profile, :default => true
  preference :dark_chocolate, :default => true
  has_many :media_newsletter_subscriptions, :dependent => :destroy

  has_many :page_views, :as => :page_owner, :dependent => :destroy
  has_many :trace_searches, :as => :keywordable
  has_many :trace_keywords, :as => :keywordable
  has_many :soapbox_trace_keywords, :as => :keywordable


  # For pagination
  cattr_reader :per_page
  @@per_page = 15

  scope :with_twitter, lambda {
    { :conditions => "atoken IS NOT NULL AND asecret IS NOT NULL" }
  }

  scope :with_facebook_page, lambda {
    { :conditions => "facebook_page_id IS NOT NULL AND facebook_page_token IS NOT NULL" }
  }

  scope :activated_restaurant, :conditions => { } # TODO for workound I removed is_activated =>true Ticket 36397415 
  
  #get only premium restaurants
  scope :from_premium_restaurants, lambda {
    { :joins => :subscription ,
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
  }
  # create a new named scope bcause not find any method with name subscription_is_active
  scope :subscription_is_active, lambda {
    { :joins => :subscription ,
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
  }

  attr_accessible :name, :description, :street1, :street2, :city, :state, :zip, :phone_number, :metropolitan_area_id,
   :james_beard_region_id, :manager_id, :media_contact_id, :cuisine_id, :opening_date, :website, :management_company_name,
   :management_company_website, :logo_attributes, :attachment, :photos_attributes,:primary_photo,:facebook_page_id, :facebook_page_token, :facebook_page_url,
   :atoken, :asecret,:last_newsletter_at, :newsletter_approved,:subscription,:sort_name, :hours,
   :twitter_handle, :is_activated, :id,:manager,:metropolitan_area, :james_beard_region,:cuisine, :media_contact


  def self.find_premium(id)
    #possibility = find_by_id(id)
    possibility = find(id)
    possibility.try(:premium_account) ? possibility : nil
  end

  def self.with_feature(feature)
    Restaurant.all(:joins => :restaurant_feature_items,
                   :conditions => ['restaurant_feature_items.restaurant_feature_id = ?', feature.id])
  end

  def top_tags
    #restaurant_feature_items.all(:limit => 15, :conditions => { :top_tag => true }).map(&:restaurant_feature)
    restaurant_feature_items.find(:all,:conditions => { :top_tag => true },:limit => 3).map(&:restaurant_feature) 
  end

  def top_limited_tags(no)
    restaurant_feature_items.all(:limit => no, :conditions => { :top_tag => true }).map(&:restaurant_feature)
  end

  def name_and_location
    [name, city, state].reject(&:blank?).join(", ")
  end

  def city_and_state
    [city, state].reject(&:blank?).join(", ")
  end

  def missing_subject_matters
    SubjectMatter.find(missing_subject_matter_ids)
  end

  def destroy_without_callbacks
    self.update_attribute(:deleted_at, Time.now.utc)
  end

  def restaurant_and_city
    [name.capitalize, city].reject(&:blank?).join(", ")
  end
  # Override the default destroy to allow us to flag deleted_at.
  # This preserves the before_destroy and after_destroy callbacks.
  # Because this is also called internally by Model.destroy_all and
  # the Model.destroy(id), we don't need to specify those methods
  # separately.
  def destroy
    return false if run_callbacks(:destroy){ true } == false
    result = destroy_without_callbacks
    run_callbacks(:destroy){ true }
    result
  end

  def self.find_with_destroyed(*args)
    self.with_exclusive_scope { find(*args) }
  end

  def self.with_destroyed(&block)
    self.with_exclusive_scope(&block)
  end

  def reset_features(add_ids, remove_ids = [])
    self.restaurant_feature_ids = ((self.restaurant_feature_ids - remove_ids.map(&:to_i)) + add_ids.map(&:to_i)).uniq.sort
    self.restaurant_feature_ids
  end

  def feature_categories
    restaurant_features.map(&:restaurant_feature_category).uniq
  end

  def feature_pages
    feature_categories.map(&:restaurant_feature_page).uniq
  end

  def features_for_page(feature_page)
    restaurant_features.select { |feature| feature.restaurant_feature_page == feature_page }.sort_by(&:value)
  end

  def features_for_category(feature_category)
    restaurant_features.select { |feature| feature.restaurant_feature_category == feature_category }.sort_by(&:value)
  end

  def categories_for_page(feature_page)
    feature_categories.select { |cat| cat.restaurant_feature_page == feature_page }.sort_by(&:name)
  end

  def public_employments
    employments.public_profile_only.by_position
  end

  def braintree_contact
    # need to get this fresh, in case it's being called from a callback
    User.find(self.manager_id)
  end

  def additional_managers
    self.managers - [self.manager]
  end

  def questions(opts = {})
    RestaurantQuestion.all(opts)
  end

  def topics
    RestaurantTopic.all
  end

  def published_topics
    topics.select { |t| t.published?(self) }
  end

  def linkable_profile?
    self.prefers_publish_profile? && self.premium_account?
  end

  def menus_last_updated
    menus.present? ? menus.first(:order => "updated_at DESC").updated_at.strftime('%m/%d/%y') : ''
  end

  def photos_last_updated
   if  !photos.present? && photos.first.nil?
    ""
   elsif photos.present?
     photos.first.id.blank? ? "" : photos.first(:order => "updated_at DESC").updated_at.strftime('%m/%d/%y')
   end
  end

  def shareable_newsletter_subscribers
    newsletter_subscribers.all(:conditions => ["newsletter_subscriptions.share_with_restaurant = ?", true])
  end

  def self.send_newsletter_preview_reminder
    for restaurant in Restaurant.with_premium_account
      restaurant.send_later(:send_newsletter_preview_reminder)
    end
  end

  def send_newsletter_preview_reminder
    UserMailer.newsletter_preview_reminder(self).deliver
  end

  def mailchimp_group_name
    "#{name} in #{city} #{state}"
  end
  def mailchimp_group_name_media
    "#{name} in #{city} #{state} media"
  end
  def next_newsletter_for_frequency
     case newsletter_frequency
    when "weekly"
      Chronic.parse("week #{newsletter_frequency_day} 12:00am")
    when "biweekly"
      Chronic.parse("next week #{newsletter_frequency_day} 12:00am")
    when "monthly"
      Chronic.parse("next month #{newsletter_frequency_day} 12:00am")
    else      
      Chronic.parse("next #{newsletter_frequency} 12:00am")
    end
  end

  def self.send_newsletters
    for restaurant in Restaurant.with_premium_account
      if restaurant.next_newsletter_at < Time.now && restaurant.newsletter_approved
        restaurant.send_later(:send_newsletter_to_subscribers)
        restaurant.update_attribute(:next_newsletter_at, restaurant.next_newsletter_for_frequency)
      end
    end
  end

  def send_newsletter_to_subscribers
    
    if self.newsletter_approved
      # create newsletter
      newsletter = RestaurantNewsletter.create_with_content(id)
      # connect to Mailchimp
      mc = MailchimpConnector.new
      mail_subj = self.newsletter_setting.subject.blank? ? "#{name} Soapbox Newsletter for #{Date.today}" : self.newsletter_setting.subject
      newsletter.update_attributes(:subject => mail_subj)    
      # create new campaign with content for the restaurant, selecting the correct subscribers
      campaign_id = \
      mc.client.campaign_create(:type => "regular",
                                :options => { :list_id => mc.mailing_list_id,
                                              :subject => mail_subj,
                                              :from_email => "info@restaurantintelligenceagency.com",
                                              :to_name => "*|FNAME|*",
                                              :from_name => "Restaurant Intelligence Agency",
                                              :generate_text => true },
                                :segment_opts => { :match=>"any",
                                                  :conditions=>[{:field=>"interests-#{mc.grouping_id}",:op => "all",:value => self.mailchimp_group_name}]},
                                :content => { :url => restaurant_newsletter_url(self, newsletter) })
      # send campaign
      if mc.client.campaign_send_now(:cid => campaign_id)
        newsletter.update_attributes(:campaign_id=>campaign_id)
      end
      self.newsletter_setting.subject
      update_attributes(:last_newsletter_at => Time.now, :newsletter_approved => false)
    end
  end

  def get_campaign
    status_data = Hash.new
    mc = MailchimpConnector.new
      self.restaurant_newsletters.each do |r|
      data = mc.client.campaign_stats(:cid=>r.campaign_id)
      status_data[r.id] = {:data=>data,:newsletter =>r}
     end
    return status_data
  end 

  def self.extended_find(keyword)
    # when searchlogic will be updated, instead of all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # one can use id_not_in(restaurants.map(&:id))

    premiums = Restaurant.activated_restaurant.subscription_is_active

    # RESTAURANT: name, city, state, management_company_name
    restaurants = premiums.search(:name_or_city_or_state_or_management_company_name_like=>keyword).relation
    # RESTAURANT->CUISINE: name
    restaurants += premiums.search(:cuisine_name_like=>keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # RESTAURANT->METROPOLITAN AREA: name
    restaurants += premiums.search(:metropolitan_area_name_like=>keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # RESTAURANT->ACCOLADE: name
    restaurants += premiums.search(:accolades_name_like=>keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # RESTAURANT->RESTAURANT FEATURES: value
    restaurants += premiums.search(:restaurant_features_value_like=>keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # RESTAURANT->RESTAURANT FEATURES->RESTAURANT FEATURE CATEGORY: name
    restaurants += premiums.search(:restaurant_features_restaurant_feature_category_name_like=>keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # RESTAURANT->RESTAURANT FEATURES->RESTAURANT FEATURE CATEGORY->RESTAURANT FEATURE PAGE: name
    restaurants += premiums.search(:restaurant_features_restaurant_feature_category_restaurant_feature_page_name_like=>keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)], :group => "restaurants.id")
    # RESTAURANT->MENUS: name
    restaurants += premiums.search(:menus_name_like=>keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # RESTAURANT->RESTAURANT FACT SHEETS:
    #      venue, neighborhood, wine_by_the_bottle_details, reservations, dress_code, delivery
    #      architect_name, graphic_designer, furniture_designer, flooring, millwork, china
    #      kitchen_equipment, lighting, draperies, smoking
    restaurants += premiums.
      search(:fact_sheet_venue_or_fact_sheet_neighborhood_or_fact_sheet_wine_by_the_bottle_details_or_fact_sheet_reservations_like=>keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    restaurants += premiums.
      search(:fact_sheet_dress_code_or_fact_sheet_delivery_or_fact_sheet_architect_name_or_fact_sheet_graphic_designer_like=>keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    restaurants += premiums.
      search(:fact_sheet_furniture_designer_or_fact_sheet_flooring_or_fact_sheet_millwork_or_fact_sheet_china_like=>keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    restaurants += premiums.
      search(:fact_sheet_kitchen_equipment_or_fact_sheet_lighting_or_fact_sheet_draperies_or_fact_sheet_smoking_like=>keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])

    restaurants
  end
  def is_activated_restaurant? 
      is_activated
  end

  def self.only_deleted_restaurants
    with_exclusive_scope{Restaurant.find(:all,:conditions=>"deleted_at is not null" ,:order=>"created_at desc")}
  end

  def post_to_fb_url social_post
    path = nil    
    case social_post.source_type
      when "MenuItem"
        path = facebook_post_restaurant_menu_item_path(self, social_post.source,{:social_id=>social_post.id})
      when "Promotion" 
        path = facebook_post_restaurant_promotion_path(self, social_post.source,{:social_id=>social_post.id})
      when "ALaMinuteAnswer"
        path = facebook_post_restaurant_a_la_minute_answer_path(self, social_post.source,{:social_id=>social_post.id})
    end 
    path 
  end
   #TODU When a credit card declines, an email goes to admin, the user is alerted three times over the course of 10 days,
  def send_user_alert_for_payment_declined restaurant
   if restaurant.count.nil? || restaurant.count < 3
      restaurant.increment!(:count)      
   elsif restaurant.count == 3
    restaurant.admin_cancel #TODU make account to basic if payement decline
   end     
   UserMailer.send_user_alert_for_payment_declined_email(restaurant).deliver
  end


  private

  def add_manager_as_employee
    self.employees << manager if manager
    manager.default_employment.try(:destroy)
  end

  def update_manager
    self.employments.first.update_attribute(:omniscient, true) if employments.any?
  end

  def handled_subject_matter_ids
    employments.all(:include => :responsibilities).map(&:subject_matter_ids).flatten.uniq
  end

  def missing_subject_matter_ids
    (SubjectMatter.all(:select => :id).map(&:id) - handled_subject_matter_ids)
  end

  def reset_primary_photo_on_add(added_photo)
    update_attributes!(:primary_photo => photos.first) if added_photo.valid? && primary_photo.nil?
  end

  def reset_primary_photo_on_remove(removed_photo)
    update_attributes!(:primary_photo => photos.first) unless photos.include?(primary_photo)
  end

  def migrate_employees_to_default_employment
    self.employments.each do |employment|
      user = employment.employee
      if user.employments.count == 0
        user.create_default_employment(:restaurant_role => employment.restaurant_role,
          :subject_matters => employment.subject_matters, :admin_messages => employment.admin_messages)
      end
    end
  end

  def add_fact_sheet
    self.fact_sheet = RestaurantFactSheet.create
  end
  def add_api_token
      self.update_attribute(:api_token,  Digest::SHA1.hexdigest(id.to_s))
  end
end
