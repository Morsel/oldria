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
#

class ALaMinuteAnswer < ActiveRecord::Base

  include ActionView::Helpers::TextHelper
  include ActionController::UrlWriter
  default_url_options[:host] = DEFAULT_HOST

  belongs_to :a_la_minute_question
  belongs_to :responder, :polymorphic => true

  validates_presence_of :a_la_minute_question_id
  validates_presence_of :answer

  default_scope :order => 'created_at desc'

  named_scope :for_question, lambda { |question| {:conditions => {:a_la_minute_question_id => question.id}} }

  named_scope :from_premium_responders, lambda {
    {
      :joins => 'INNER JOIN subscriptions ON `subscriptions`.subscriber_id = responder_id AND `subscriptions`.subscriber_type = responder_type',
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today]
    }
  }

  named_scope :from_responders, lambda { |restaurants|
    {
      :conditions => ["id in (?)", restaurants.map(&:id)]
    }
  }

  attr_accessor :no_twitter_crosspost, :no_fb_crosspost
  after_create :crosspost

  def self.newest_for(obj)
    ids = []
    if obj.is_a?(Restaurant) || obj.is_a?(User)
      ids = obj.a_la_minute_answers.maximum(:created_at, :group => :a_la_minute_question_id, :select => :id).collect{|k,v|v}
      obj.a_la_minute_answers.find(ids)
    else
      ids = obj.a_la_minute_answers.maximum(:created_at, :group => 'responder_type, responder_id', :select => :id).collect{|k,v|v}
    end
    obj.a_la_minute_answers.find(ids)
  end

  def self.public_profile_for(responder)
    ids = responder.a_la_minute_answers.maximum(:created_at, :group => :a_la_minute_question_id, :select => :id).collect{|k,v|v}
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
    # restaurants = search_params.present? ? Restaurant.with_premium_account.search(search_params).all : Restaurant.with_premium_account
    self.from_responders(Restaurant.with_premium_account).map { |a| { :post => a.answer,
                                                  :restaurant => a.restaurant,
                                                  :created_at => a.created_at,
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

  private

  def crosspost
    update_attribute(:post_to_twitter_at, nil) if no_twitter_crosspost == "1"
    if post_to_twitter_at.present? && responder.twitter_authorized?
      responder.twitter_client.send_at(post_to_twitter_at, :update, "#{truncate(answer, :length => 120)} #{self.bitly_link}")
    end

    update_attribute(:post_to_facebook_at, nil) if no_fb_crosspost == "1"
    if post_to_facebook_at.present? && responder.has_facebook_page?
      post_attributes = { :message     => answer,
                          :link        => soapbox_a_la_minute_answer_url(self),
                          :name        => question,
                          :description => answer }
      responder.send_at(post_to_facebook_at, :post_to_facebook_page, post_attributes)
    end
  end

end
