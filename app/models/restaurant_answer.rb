# == Schema Information
# Schema version: 20120217190417
#
# Table name: restaurant_answers
#
# id :integer not null, primary key
# restaurant_question_id :integer
# answer :text
# restaurant_id :integer
# created_at :datetime
# updated_at :datetime
#

class RestaurantAnswer < ActiveRecord::Base
  include ActionDispatch::Routing::UrlFor
include Rails.application.routes.url_helpers
default_url_options[:host] = DEFAULT_HOST

  belongs_to :restaurant_question
  belongs_to :restaurant

  validates_presence_of :answer, :restaurant_question_id, :restaurant_id
  validates_uniqueness_of :restaurant_question_id, :scope => :restaurant_id

  scope :from_premium_restaurants, lambda {
    {
      :joins => { :restaurant => :subscription },
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today]
    }
  }

  scope :recently_answered, :order => "restaurant_answers.created_at DESC"

  scope :activated_restaurants, lambda {
    {
      :joins => 'INNER JOIN restaurants as res ON `res`.id = restaurant_id ',
      :conditions => ["(res.is_activated = ?)", true]
    }
  }

  # for twitter and facebook share associations
  has_many :twitter_posts, :as => :source, :dependent => :destroy
  accepts_nested_attributes_for :twitter_posts, :limit => 1, :allow_destroy => true, :reject_if => TwitterPost::REJECT_PROC

  has_many :facebook_posts, :as => :source, :dependent => :destroy
  accepts_nested_attributes_for :facebook_posts, :limit => 1, :allow_destroy => true, :reject_if => FacebookPost::REJECT_PROC
  # end twitter and fb share associations
  attr_accessible :restaurant,:restaurant_question_id, :id, :restaurant_id, :answer, :twitter_posts_attributes, :facebook_posts_attributes

  def bitly_link
    client = Bitly.new(BITLY_CONFIG['username'], BITLY_CONFIG['api_key'])
    client.shorten(soapbox_restaurant_question_url(restaurant_question_id)).short_url
  rescue => e
    Rails.logger.error("Bit.ly error: #{e.message}")
    soapbox_restaurant_question_url(restaurant_question_id)
  end


  def post_to_twitter(message=nil)
    message = message.blank? ? answer : message
    message = "#{truncate(message,:length => (135-self.bitly_link.length))} #{self.bitly_link}"
    restaurant.twitter_client.update(message)
  end

  def post_to_facebook(message=nil)
    message = message.blank? ? answer : message
    post_attributes = {
      :message => restaurant_question.title,
      :link => soapbox_restaurant_question_url(restaurant_question_id),
      :name => nil,
      :description => Loofah::Helpers.sanitize(message.gsub(/(<[^>]*>)|\r|\t/s) {" "})
    }
    restaurant.post_to_facebook_page(post_attributes)
  end

  def activity_name
    "Restaurant Question Answer"
  end

  def edit_path(options={})
    # edit_restaurant_menu_item_path(restaurant, self, options)
  end  



end

