# == Schema Information
#
# Table name: menu_items
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  description         :text
#  price               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  restaurant_id       :integer
#  photo_file_name     :string(255)
#  photo_content_type  :string(255)
#  photo_file_size     :integer
#  photo_updated_at    :datetime
#  pairing             :string(255)
#  post_to_twitter_at  :datetime
#  post_to_facebook_at :datetime
#

class MenuItem < ActiveRecord::Base

  include ActionView::Helpers::TextHelper
  include ActionController::UrlWriter
  default_url_options[:host] = DEFAULT_HOST

  belongs_to :restaurant

  has_many :menu_item_keywords, :dependent => :destroy
  has_many :otm_keywords, :through => :menu_item_keywords

  has_one :twitter_job, :class_name => "Delayed::Job", :foreign_key => 'id', :primary_key => 'twitter_job_id', :dependent => :destroy
  has_one :facebook_job, :class_name => "Delayed::Job", :foreign_key => 'id', :primary_key => 'facebook_job_id', :dependent => :destroy

  has_attached_file :photo,
                    :storage        => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/environments/#{RAILS_ENV}/amazon_s3.yml",
                    :path           => "#{RAILS_ENV}/otm_photos/:id/:style/:filename",
                    :bucket         => "spoonfeed",
                    :url            => ':s3_domain_url',
                    :styles         => { :full => "1966x2400>", :large => "360x480>", :medium => "240x320>", :small => "189x150>", :thumb => "120x160>" }

  validates_attachment_content_type :photo,
      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png"],
      :message => "Please upload a valid image type: jpeg, gif, or png", :if => :photo_file_name

  validates_presence_of :name, :description, :restaurant
  validates_format_of :price, :with => RestaurantFactSheet::MONEY_FORMAT

  named_scope :from_premium_restaurants, lambda {
    { :joins => { :restaurant => :subscription },
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
  }

  named_scope :activated_restaurants, {
    :joins => :restaurant,
    :conditions => ["restaurants.is_activated = ?", true]
  }

  attr_accessor :no_twitter_crosspost, :no_fb_crosspost
  after_create :crosspost

  def keywords
    otm_keywords.map { |k| "#{k.category}: #{k.name}" }.to_sentence
  end

  def keywords_without_categories
    otm_keywords.map { |k| "#{k.name}" }.to_sentence
  end

  def activity_name
    "On the Menu item"
  end

  def self.email_address_for_restaurant(restaurant)
    "otm-#{restaurant.id}@#{CLOUDMAIL_DOMAIN}"
  end

  def self.build_with_photo_url(params = {})
    io = open(params.delete(:photo_url))
    def io.original_filename; base_uri.path.split('/').last; end
    photo = io.original_filename.blank? ? nil : io
    MenuItem.new(params.merge(:photo => photo))
  end

  def bitly_link
    client = Bitly.new(BITLY_CONFIG['username'], BITLY_CONFIG['api_key'])
    client.shorten(soapbox_menu_item_url(self)).short_url
  rescue => e
    Rails.logger.error("Bit.ly error: #{e.message}")
    soapbox_menu_item_url(self)
  end

  def queue_for_facebook_page
    picture_url = self.photo(:large) if self.photo_file_name.present?
    post_attributes = { :message     => "New on the menu: #{name}",
                        :link        => soapbox_menu_item_url(self),
                        :name        => name,
                        :description => Loofah::Helpers.strip_tags(description),
                        :picture     => picture_url }
    facebook_job = restaurant.send_at(post_to_facebook_at, :post_to_facebook_page, post_attributes)
    update_attribute(:facebook_job_id, facebook_job.id)
  end

  def update_crosspost
    crosspost
  end

  def self.todays_cloud_keywords            
    MenuItem.all(:include=> :otm_keywords,:conditions=>["created_at > DATE(?) ",(Time.now - 24.hours)])
  end

  def self.filter_cloud_keywords(from=nil,to=nil)
      unless (to.nil?)
        MenuItem.all(:joins=> :otm_keywords,:conditions=>["menu_items.created_at < DATE(?) and  menu_items.created_at > DATE(?)",(Time.now - from), (Time.now - to)],:group=>"otm_keywords.name",:limit=>5)
      else
        MenuItem.all(:joins=> :otm_keywords,:conditions=>["menu_items.created_at < DATE(?) ",(Time.now - from)],:group=>"otm_keywords.name",:limit=>5) 
      end  
  end

 
  private

  def crosspost
    # Post to Twitter
    if twitter_job.present?
      twitter_job.destroy
      update_attribute(:twitter_job_id, nil)
    end

    update_attribute(:post_to_twitter_at, nil) if no_twitter_crosspost == "1"
    if post_to_twitter_at.present? && restaurant.twitter_authorized?
      twitter_job = restaurant.twitter_client.send_at(post_to_twitter_at, :update, "#{truncate(name, :length => 120)} #{self.bitly_link}")
      update_attribute(:twitter_job_id, twitter_job.id)
    end

    # Post to Facebook
    if facebook_job.present?
      facebook_job.destroy
      update_attribute(:facebook_job_id, nil)
    end

    update_attribute(:post_to_facebook_at, nil) if no_fb_crosspost == "1"
    if post_to_facebook_at.present? && restaurant.has_facebook_page?
      queue_for_facebook_page
    end
  end

end
