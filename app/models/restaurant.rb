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
  include FacebookPageConnect
  include TwitterAuthorization

  include ActionController::UrlWriter
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

  accepts_nested_attributes_for :logo

  validates_presence_of :name, :street1, :city, :state, :zip, :phone_number,
      :metropolitan_area, :website, :media_contact, :cuisine, :opening_date, :manager

  validates_format_of :management_company_website,
      :with => URI::regexp(%w(http https)),
      :message => "needs to be a valid URL that starts with http://",
      :allow_blank => true

  validates_format_of :facebook_page_url,
      :with => %r{^https*://www\.facebook\.com(.*)},
      :allow_blank => true,
      :message => "Facebook page must start with http://www.facebook.com"

  validates_inclusion_of :newsletter_frequency, :in => ["weekly", "biweekly", "monthly"]

  has_one :subscription, :as => :subscriber
  after_validation_on_create :add_manager_as_employee
  after_create :update_manager
  before_destroy :migrate_employees_to_default_employment

  has_one :fact_sheet, :class_name => "RestaurantFactSheet"
  after_create :add_fact_sheet

  preference :publish_profile, :default => true
  
  # For pagination
  cattr_reader :per_page
  @@per_page = 15

  named_scope :with_twitter, lambda {
    { :conditions => "atoken IS NOT NULL AND asecret IS NOT NULL" }
  }

  named_scope :with_facebook_page, lambda {
    { :conditions => "facebook_page_id IS NOT NULL AND facebook_page_token IS NOT NULL" }
  }

  named_scope :activated_restaurant, :conditions => { } # TODO for workound I removed is_activated =>true Ticket 36397415 

  def self.find_premium(id)
    possibility = find_by_id(id)
    possibility.try(:premium_account) ? possibility : nil
  end

  def self.with_feature(feature)
    Restaurant.all(:joins => :restaurant_feature_items,
                   :conditions => ['restaurant_feature_items.restaurant_feature_id = ?', feature.id])
  end

  def top_tags
    restaurant_feature_items.all(:limit => 15, :conditions => { :top_tag => true }).map(&:restaurant_feature)
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
    return false if callback(:before_destroy) == false
    result = destroy_without_callbacks
    callback(:after_destroy)
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
    photos.present? ? photos.first(:order => "updated_at DESC").updated_at.strftime('%m/%d/%y') : ''
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
    UserMailer.deliver_newsletter_preview_reminder(self)
  end

  def mailchimp_group_name
    "#{name} in #{city} #{state}"
  end

  def next_newsletter_for_frequency
    case newsletter_frequency
    when "weekly"
      Chronic.parse("next week Thursday 12:00am")
    when "biweekly"
      Chronic.parse("next week Thursday 12:00am") + 1.week
    when "monthly"
      Chronic.parse("next month Thursday 12:00am")
    end
  end

  def self.send_newsletters
    for restaurant in Restaurant.with_premium_account
      if restaurant.next_newsletter_at < Time.now
        restaurant.send_later(:send_newsletter_to_subscribers)
        restaurant.update_attribute(:next_newsletter_at, restaurant.next_newsletter_for_frequency)
      end
    end
  end

  def send_newsletter_to_subscribers
    if newsletter_subscribers.present?
      # create newsletter
      newsletter = RestaurantNewsletter.create_with_content(id)
      # connect to Mailchimp
      mc = MailchimpConnector.new
      # create new campaign with content for the restaurant, selecting the correct subscribers
      campaign_id = \
      mc.client.campaign_create(:type => "regular",
                                :options => { :list_id => mc.mailing_list_id,
                                              :subject => "#{name} Soapbox Newsletter for #{Date.today}",
                                              :from_email => "info@restaurantintelligenceagency.com",
                                              :to_name => "*|FNAME|*",
                                              :from_name => "Restaurant Intelligence Agency",
                                              :generate_text => true },
                                :segment_opts => { :match => "all",
                                :conditions => [{ :field => "interests-#{mc.grouping_id}",
                                                  :op => "all",
                                                  :value => mailchimp_group_name}] },
                                :content => { :url => restaurant_newsletter_url(self, newsletter) })
      # send campaign
      mc.client.campaign_send_now(:cid => campaign_id)
      update_attribute(:last_newsletter_at, Time.now)
    end
  end

  def self.extended_find(keyword)
    # when searchlogic will be updated, instead of all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # one can use id_not_in(restaurants.map(&:id))

    premiums = Restaurant.activated_restaurant.subscription_is_active

    # RESTAURANT: name, city, state, management_company_name
    restaurants = premiums.name_or_city_or_state_or_management_company_name_like(keyword)
    # RESTAURANT->CUISINE: name
    restaurants += premiums.cuisine_name_like(keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # RESTAURANT->METROPOLITAN AREA: name
    restaurants += premiums.metropolitan_area_name_like(keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # RESTAURANT->ACCOLADE: name
    restaurants += premiums.accolades_name_like(keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # RESTAURANT->RESTAURANT FEATURES: value
    restaurants += premiums.restaurant_features_value_like(keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # RESTAURANT->RESTAURANT FEATURES->RESTAURANT FEATURE CATEGORY: name
    restaurants += premiums.restaurant_features_restaurant_feature_category_name_like(keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # RESTAURANT->RESTAURANT FEATURES->RESTAURANT FEATURE CATEGORY->RESTAURANT FEATURE PAGE: name
    restaurants += premiums.restaurant_features_restaurant_feature_category_restaurant_feature_page_name_like(keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)], :group => "restaurants.id")
    # RESTAURANT->MENUS: name
    restaurants += premiums.menus_name_like(keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    # RESTAURANT->RESTAURANT FACT SHEETS:
    #      venue, neighborhood, wine_by_the_bottle_details, reservations, dress_code, delivery
    #      architect_name, graphic_designer, furniture_designer, flooring, millwork, china
    #      kitchen_equipment, lighting, draperies, smoking
    restaurants += premiums.
      fact_sheet_venue_or_fact_sheet_neighborhood_or_fact_sheet_wine_by_the_bottle_details_or_fact_sheet_reservations_like(keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    restaurants += premiums.
      fact_sheet_dress_code_or_fact_sheet_delivery_or_fact_sheet_architect_name_or_fact_sheet_graphic_designer_like(keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    restaurants += premiums.
      fact_sheet_furniture_designer_or_fact_sheet_flooring_or_fact_sheet_millwork_or_fact_sheet_china_like(keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])
    restaurants += premiums.
      fact_sheet_kitchen_equipment_or_fact_sheet_lighting_or_fact_sheet_draperies_or_fact_sheet_smoking_like(keyword).
      all(:conditions => ["restaurants.id NOT in (?)", [0] + restaurants.map(&:id)])

    restaurants
  end
  def is_activated_restaurant? 
      is_activated
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
    (SubjectMatter.general.all(:select => :id).map(&:id) - handled_subject_matter_ids)
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
  
end
