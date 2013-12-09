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

  include ActionDispatch::Routing::UrlFor
include Rails.application.routes.url_helpers
default_url_options[:host] = DEFAULT_HOST

  belongs_to :restaurant

  has_many :menu_item_keywords, :dependent => :destroy
  has_many :otm_keywords, :through => :menu_item_keywords
  has_many :trace_keywords, :as => :keywordable
  has_many :soapbox_trace_keywords, :as => :keywordable

  has_many :twitter_posts, :as => :source, :dependent => :destroy
  accepts_nested_attributes_for :twitter_posts, :limit => 3, :allow_destroy => true, :reject_if => TwitterPost::REJECT_PROC

  has_many :facebook_posts, :as => :source, :dependent => :destroy
  accepts_nested_attributes_for :facebook_posts, :limit => 3, :allow_destroy => true, :reject_if => FacebookPost::REJECT_PROC

  has_attached_file :photo,
                    :storage        => :s3,
                    :s3_credentials => "#{Rails.root}/config/environments/#{Rails.env}/amazon_s3.yml",
                    :path           => "#{Rails.env}/otm_photos/:id/:style/:filename",
                    :bucket         => "spoonfeed",
                    :url            => ':s3_domain_url',
                    :styles         => { :full => "1966x2400>", :large => "360x480>", :medium => "240x320>", :small => "189x150>", :thumb => "120x160>" }
  validates_attachment_size :photo, :less_than => 3.megabytes,:message => "is too large for uploading the twitter please select the size less then 3 megabytes.", :if => :photo_file_name
  validates_attachment_content_type :photo,
      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png"],
      :message => "Please upload a valid image type: jpeg, gif, or png", :if => :photo_file_name

  validates_presence_of :name, :description, :restaurant,:photo
  validates_format_of :price, :with => RestaurantFactSheet::MONEY_FORMAT

  scope :from_premium_restaurants, lambda {
    { :joins => { :restaurant => :subscription },
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
  }

  scope :activated_restaurants, {
    :joins => :restaurant,
    :conditions => ["restaurants.is_activated = ?", true]
  }

  attr_accessor :search_keywords
  attr_accessible :post_to_twitter_at, :post_to_facebook_at,:name, :description, :price, :pairing, :search_keywords, :otm_keyword_ids,
  :photo, :twitter_posts_attributes, :facebook_posts_attributes, :otm_keywords
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
    "otm-#{restaurant.id}@staging-mailbot.restaurantintelligenceagency.com"
    #{}"otm-#{restaurant.id}@#{CLOUDMAIL_DOMAIN}"
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

  def twitter_message
    "#{self.name[0..120]}"
  end

  def facebook_message
    "New on the menu: #{self.name}"
  end

  def post_to_twitter(message=nil)
    picture_url = self.photo(:full) if self.photo_file_name.present?
    picture = nil
    unless picture_url.blank?
      begin
        picture  = open(URI.parse(URI.encode(picture_url.strip)))
      rescue        
      end
    end    
    message = message.blank? ? twitter_message : message
    if(picture.nil?)
      restaurant.twitter_client.update("#{message[0..(135-self.bitly_link.length)]} #{self.bitly_link}")
    else
      restaurant.twitter_client.update_with_media("#{message[0..(90-self.bitly_link.length)]} #{self.bitly_link}",picture)
    end  
  end

  def post_to_facebook(message=nil)
    picture_url = self.photo(:full) if self.photo_file_name.present?
    message = message.blank? ? facebook_message : message
    unless self.photo_file_name.present? 
      picture_url = (restaurant.logo && restaurant.logo.attachment?) ? restaurant.logo.attachment.url(:medium) : nil
    end  
    post_attributes = {
      :message     => message,
      :link        => soapbox_menu_item_url(self),
      :name        => name,
      :description => Loofah::Helpers.strip_tags(description.gsub(/(<[^>]*>)|\r|\t/s) {" "}),
      :picture     => picture_url,
      :timeline    => self.photo_file_name.present? ? true : false
    }
    restaurant.post_to_facebook_page(post_attributes)
  end

  def edit_path(options={})
    edit_restaurant_menu_item_path(restaurant, self, options)
  end

end
