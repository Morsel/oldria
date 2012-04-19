# == Schema Information
# Schema version: 20120217190417
#
# Table name: menu_items
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  description        :text
#  price              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  restaurant_id      :integer
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  pairing            :string(255)
#

class MenuItem < ActiveRecord::Base

  include ActionView::Helpers::TextHelper
  include ActionController::UrlWriter
  default_url_options[:host] = DEFAULT_HOST

  belongs_to :restaurant

  has_many :menu_item_keywords, :dependent => :destroy
  has_many :otm_keywords, :through => :menu_item_keywords

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

  validates_presence_of :name
  validates_format_of :price, :with => RestaurantFactSheet::MONEY_FORMAT

  named_scope :from_premium_restaurants, lambda {
    { :joins => { :restaurant => :subscription },
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
  }

  attr_accessor :post_to_twitter, :post_to_facebook_page
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

  private

  def crosspost
    if post_to_twitter == "1"
      client = Bitly.new(BITLY_CONFIG['username'], BITLY_CONFIG['api_key'])
      link = client.shorten(soapbox_menu_item_url(self))
      restaurant.twitter_client.send_later(:update, "#{truncate(name, :length => 120)} #{link.short_url}")
    end
    if post_to_facebook_page == "1"
      picture_url = self.photo.url if self.photo_file_name.present?
      post_attributes = { :message     => "New on the menu: #{name}",
                          :link        => soapbox_menu_item_url(self),
                          :name        => name,
                          :description => description,
                          :picture     => picture_url }
      restaurant.send_later(:post_to_facebook_page, post_attributes)
    end
  end

end
