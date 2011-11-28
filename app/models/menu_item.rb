# == Schema Information
# Schema version: 20111115211957
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
                    :styles => { :full => "1966x2400>", :large => "360x480>", :medium => "240x320>", :thumb => "120x160>" }

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

  attr_accessor :post_to_twitter
  attr_accessor :user_id
  after_create :crosspost

  def keywords
    otm_keywords.map { |k| "#{k.category}: #{k.name}" }.to_sentence
  end

  def keywords_without_categories
    otm_keywords.map { |k| "#{k.name}" }.to_sentence
  end

  private

  def crosspost
    if post_to_twitter == "1"
      User.find(user_id).twitter_client.update("#{truncate(name, :length => 100)} #{soapbox_menu_item_url(self)}")
    end
  end

end
