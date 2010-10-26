# == Schema Information
# Schema version: 20101022194902
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
#  description                :string(255)
#  phone_number               :string(255)
#  website                    :string(255)
#  twitter_username           :string(255)
#  facebook_page              :string(255)
#  hours                      :string(255)
#  media_contact_id           :integer
#  management_company_name    :string(255)
#  management_company_website :string(255)
#  logo_id                    :integer
#  primary_photo_id           :integer
#  opening_date               :date
#  premium_account            :boolean
#  sort_name                  :string(255)
#

class Restaurant < ActiveRecord::Base
  apply_addresslogic
  default_scope :conditions => {:deleted_at => nil}

  belongs_to :manager, :class_name => "User", :foreign_key => 'manager_id'
  belongs_to :metropolitan_area
  belongs_to :james_beard_region
  belongs_to :cuisine
  has_many :employments, :dependent => :destroy
  has_many :employees, :through => :employments
  has_many :additional_managers,
           :through => :employments,
           :source => :employee,
           :conditions => {:employments => {:omniscient => true}}
  has_many :media_request_discussions
  has_many :media_requests, :through => :media_request_discussions
  has_many :admin_discussions, :dependent => :destroy
  has_many :holiday_discussions, :dependent => :destroy
  has_many :holidays, :through => :holiday_discussions

  has_many :trend_questions, :through => :admin_discussions,
           :source => :discussionable, :source_type => 'TrendQuestion'
  has_many :content_requests, :through => :admin_discussions,
           :source => :discussionable, :source_type => 'ContentRequest'

  has_many :events
  has_many :menus
  has_many :accolades, :as => :accoladable
  has_many :a_la_minute_answers, :as => :responder

  belongs_to :media_contact, :class_name => "User", :foreign_key => 'media_contact_id'

  after_validation_on_create :add_manager_as_employee
  after_save :update_admin_discussions

  has_and_belongs_to_many :restaurant_features,
      :include => {:restaurant_feature_category => :restaurant_feature_page}

  has_many :photos, :class_name => "Photo", :as => :attachable, :order => "position ASC", :dependent => :destroy, :after_add => :reset_primary_photo_on_add, :after_remove => :reset_primary_photo_on_remove
  belongs_to :primary_photo, :class_name => "Photo", :dependent => :destroy
  belongs_to :logo, :class_name => "Image", :dependent => :destroy

  accepts_nested_attributes_for :logo

  validates_presence_of :name, :street1, :city, :state, :zip, :phone_number,
      :metropolitan_area, :website, :media_contact, :hours, :cuisine, :opening_date

  validates_format_of :website, :with => URI::regexp(%w(http https)), :message => "Needs to be a valid URL"
  validates_format_of :management_company_website,
      :with => URI::regexp(%w(http https)),
      :message => "Needs to be a valid URL",
      :allow_blank => true

  validates_format_of :facebook_page,
      :with => %r{^http://www\.facebook\.com(.*)},
      :allow_blank => true,
      :message => "Facebook page must start with http://www.facebook.com"

  # For pagination
  cattr_reader :per_page
  @@per_page = 15

  def self.with_feature(feature)
    Restaurant.all(:include => :restaurant_features,
        :conditions => ['restaurant_features_restaurants.restaurant_feature_id = ?', feature.id])
  end
  
  def self.find_premium(id)
    find_by_id_and_premium_account(id, true)
  end

  def name_and_location
    [name, city, state].reject(&:blank?).join(", ")
  end

  def missing_subject_matters
    SubjectMatter.find(missing_subject_matter_ids)
  end

  def destroy_without_callbacks
    self.update_attribute(:deleted_at, Time.now.utc)
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

  def reset_features(feature_ids)
    self.restaurant_feature_ids = feature_ids
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

  def account_type
    if premium_account then "Premium" else "Basic" end
  end

  private

  def add_manager_as_employee
    self.employees << manager if manager
  end

  def handled_subject_matter_ids
    employments.all(:include => :responsibilities).map(&:subject_matter_ids).flatten.uniq
  end

  def missing_subject_matter_ids
    (SubjectMatter.general.all(:select => :id).map(&:id) - handled_subject_matter_ids)
  end

  def update_admin_discussions
    # force trend questions to refresh associated restaurants and discussions
    TrendQuestion.all.each(&:touch)
  end

  def reset_primary_photo_on_add(added_photo)
    update_attributes!(:primary_photo => photos.first) if added_photo.valid? && primary_photo.nil?
  end

  def reset_primary_photo_on_remove(removed_photo)
    update_attributes!(:primary_photo => photos.first) unless photos.include?(primary_photo)
  end


end

