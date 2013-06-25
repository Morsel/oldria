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

  belongs_to :restaurant_question
  belongs_to :restaurant

  validates_presence_of :answer, :restaurant_question_id, :restaurant_id
  validates_uniqueness_of :restaurant_question_id, :scope => :restaurant_id

  named_scope :from_premium_restaurants, lambda {
    {
      :joins => { :restaurant => :subscription },
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today]
    }
  }

  named_scope :recently_answered, :order => "restaurant_answers.created_at DESC"

  named_scope :activated_restaurants, lambda {
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


  def bitly_link
    client = Bitly.new(BITLY_CONFIG['username'], BITLY_CONFIG['api_key'])
    client.shorten(restaurant_question_url(self)).short_url
  rescue => e
    Rails.logger.error("Bit.ly error: #{e.message}")
    restaurant_question_url(self)
  end


  def post_to_twitter(message=nil)
    message = message.blank? ? twitter_message : message
    restaurant.twitter_client.update(message)
  end

  def post_to_facebook(message=nil)
    message = message.blank? ? facebook_message : message
    post_attributes = {
      :message => message,
      :link => restaurant_question_url(self),
      :name => name,
      :description => Loofah::Helpers.sanitize(description.gsub(/(<[^>]*>)|\r|\t/s) {" "})
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

