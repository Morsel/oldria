# == Schema Information
# Schema version: 20120612214511
#
# Table name: a_la_minute_answers
#
#  id                      :integer         not null, primary key
#  answer                  :text
#  a_la_minute_question_id :integer
#  responder_id            :integer
#  responder_type          :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  post_to_twitter_at      :datetime
#  post_to_facebook_at     :datetime
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

class ALaMinuteAnswer < ActiveRecord::Base

  include ActionDispatch::Routing::UrlFor
include Rails.application.routes.url_helpers
default_url_options[:host] = DEFAULT_HOST
  attr_accessible :a_la_minute_question_id, :answer, :attachment, :photo, :twitter_posts_attributes, :facebook_posts_attributes
  has_many :trace_keywords, :as => :keywordable
  has_many :soapbox_trace_keywords, :as => :keywordable
  
  belongs_to :a_la_minute_question
  belongs_to :responder, :polymorphic => true

  has_many :twitter_posts, :as => :source, :dependent => :destroy
  accepts_nested_attributes_for :twitter_posts, :limit => 3, :allow_destroy => true, :reject_if => TwitterPost::REJECT_PROC

  has_many :facebook_posts, :as => :source, :dependent => :destroy
  accepts_nested_attributes_for :facebook_posts, :limit => 3, :allow_destroy => true, :reject_if => FacebookPost::REJECT_PROC

  validates_presence_of :a_la_minute_question_id
  validates_presence_of :answer

  # Attachments and validations
  has_attached_file :attachment,
                    :storage        => :s3,
                    :s3_credentials => "#{Rails.root}/config/environments/#{Rails.env}/amazon_s3.yml",
                    :path           => "#{Rails.env}/alaminute_answer_attachments/:id/:filename",
                    :bucket         => "spoonfeed",
                    :url            => ':s3_domain_url'

   # Attachments and validations
  has_attached_file :photo,
                    :storage        => :s3,
                    :s3_credentials => "#{Rails.root}/config/environments/#{Rails.env}/amazon_s3.yml",
                    :path           => "#{Rails.env}/alaminute_answer_attachments/:id/:style/:filename",
                    :bucket         => "spoonfeed",
                    :url            => ':s3_domain_url',
                    :styles         => { :full => "1966x2400>", :large => "360x480>", :medium => "240x320>", :small => "189x150>", :thumb => "120x160>" }
  
 

  VALID_CONTENT_TYPES = ["application/pdf", "application/x-pdf"]
  VALID_PHOTO_CONTENT_TYPES = ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png"]

  before_validation(:on => :save) do |file|
    if file.attachment_file_name.present? && (file.attachment_content_type == 'binary/octet-stream')
      mime_type = MIME::Types.type_for(file.attachment_file_name)
      file.attachment_content_type = mime_type.first.content_type if mime_type.first
    end
  end

  validate :content_type

  def content_type  
    if (!(VALID_PHOTO_CONTENT_TYPES.include?(self.photo_content_type)) && self.photo_file_name.present?)      
      errors.add(:photo, "Please upload a image type: jpeg, gif, or png") 
    end
    if !(VALID_CONTENT_TYPES.include?(self.attachment_content_type)) && self.attachment_file_name.present?
      errors.add(:attachment, "Please upload a valid pdf ") 
  end
  end


  default_scope :order => 'created_at desc'

  scope :for_question, lambda { |question| {:conditions => {:a_la_minute_question_id => question.id}} }

  scope :from_premium_responders, lambda {
    {
      :joins => 'INNER JOIN subscriptions ON `subscriptions`.subscriber_id = responder_id AND `subscriptions`.subscriber_type = responder_type',
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today]
    }
  }

  scope :activated_restaurants, lambda {
    {
      :joins => 'INNER JOIN restaurants ON `restaurants`.id = responder_id ',
      :conditions => ["responder_type = 'Restaurant'  AND (restaurants.is_activated = ?)",
          true]
    }
  }
  scope :from_responders, lambda { |restaurants|
    {
      :conditions => ["responder_id in (?)", restaurants.map(&:id)]
    }
  }

  def self.newest_for(obj)
    ids = []
    if obj.is_a?(Restaurant) || obj.is_a?(User)
      ids = obj.a_la_minute_answers.map(&:id) #obj.a_la_minute_answers.maximum(:created_at, :group => :a_la_minute_question_id, :select => :id).collect{|k,v|v}
      # obj.a_la_minute_answers.find(ids)
    else
      ids = obj.a_la_minute_answers.map(&:id) #obj.a_la_minute_answers.maximum(:created_at, :group => 'responder_type, responder_id', :select => :id).collect{|k,v|k}
    end
    obj.a_la_minute_answers.find(ids)
  end

  def self.public_profile_for(responder)
    ids = responder.a_la_minute_answers.maximum(:id, :group => :a_la_minute_question_id, :select => :id).collect{|k,v|v}
    # ids = responder.a_la_minute_answers.maximum(:created_at, :group => :a_la_minute_question_id, :select => :id).collect{|k,v|v}
    responder.a_la_minute_answers.find(ids, :order => "created_at desc")   
  end

  def self.archived_for(question)
    answers = self.for_question(question)
    answers.shift
    answers
  end

  def question
    a_la_minute_question.question
  end

  def activity_name
    "A la Minute answer to #{question}"
  end

  def restaurant
    responder
  end

  def self.social_results(search_params)
    self.from_responders(Restaurant.with_premium_account.search(search_params).all).map { |a| { :post_id => a.id,
                                                  :post_data => a.answer,
                                                  :restaurant => a.restaurant,
                                                  :post_created_at => a.created_at,
                                                  :link => a.send(:a_la_minute_answers_url, :question_id => a.a_la_minute_question.id),
                                                  :title => a.question,
                                                  :source => "Spoonfeed" } }
  end

  def bitly_link
    client = Bitly.new(BITLY_CONFIG['username'], BITLY_CONFIG['api_key'])
    client.shorten(soapbox_a_la_minute_answer_url(self)).short_url
  rescue => e
    Rails.logger.error("Bit.ly error: #{e.message}")
    soapbox_a_la_minute_answer_url(self)
  end

  def build_social_posts
    (TwitterPost::POST_LIMIT - twitter_posts.size).times { twitter_posts.build }
    (FacebookPost::POST_LIMIT - facebook_posts.size).times { facebook_posts.build }
  end

  def twitter_message
    "#{answer[0..120]} #{self.bitly_link}"
  end

  def facebook_message
    answer
  end

  def post_to_twitter(message=nil)
    message = message.blank? ? answer : message
    message = "#{message[0..(135-self.bitly_link.length)]} #{self.bitly_link}"
    restaurant.twitter_client.update(message)
  end

  def post_to_facebook(message=nil)
    message = message.blank? ? facebook_message : message
    post_attributes = {
      :message     => message,
      :link        => soapbox_a_la_minute_answer_url(self),
      :name        => question,
      :description => Loofah::Helpers.strip_tags(answer.gsub(/(<[^>]*>)|\r|\t/s) {" "})
    }
    restaurant.post_to_facebook_page(post_attributes)
  end

  def edit_path(options={})
    edit_restaurant_a_la_minute_answer_url(restaurant, self, options)
  end


end
