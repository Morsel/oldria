# == Schema Information
# Schema version: 20120217190417
#
# Table name: a_la_minute_questions
#
#  id         :integer         not null, primary key
#  question   :text
#  kind       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  topic      :string(255)
#

class ALaMinuteQuestion < ActiveRecord::Base

  KINDS = %w(restaurant user)

  has_many :trace_keywords, :as => :keywordable
  has_many :a_la_minute_answers, :dependent => :destroy

  validates_presence_of :question
  validates_inclusion_of :kind, :in => KINDS

  scope :answered, :joins => :a_la_minute_answers

  # scope :restaurants, :conditions => {:kind => "restaurant"}
  KINDS.each do |kind|
    scope :"#{kind.pluralize}", :conditions => {:kind => kind}
  end

  def answer_for(restaurant)
    restaurant.a_la_minute_answers.first(:conditions => {:a_la_minute_question_id => id})
  end

  def answers_for(restaurant)
    restaurant.a_la_minute_answers.find(:all, :conditions => {:a_la_minute_question_id => id})
  end

  def latest_answer
    a_la_minute_answers.from_premium_responders.first
  end

  def self.current_inspiration
    first(:conditions => "question LIKE 'Our current inspiration%'")
  end

  def self.most_recent_for_soapbox(count = 10)
    all(:joins => 'LEFT OUTER JOIN a_la_minute_answers
                   ON `a_la_minute_answers`.a_la_minute_question_id = `a_la_minute_questions`.id
                   INNER JOIN subscriptions
                   ON `subscriptions`.subscriber_id = `a_la_minute_answers`.responder_id
                   AND `subscriptions`.subscriber_type = `a_la_minute_answers`.responder_type',
        :order => "a_la_minute_answers.created_at DESC",
        :conditions => ["subscriptions.id IS NOT NULL
                         AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
                         Date.today]).uniq[0...count]
  end

  def answers_for_last_seven_days(restaurant)
    range = "created_at #{(7.days.ago.utc...Time.now.utc).to_s(:db)} and responder_id = #{restaurant.id}"
    self.a_la_minute_answers.find(:all,:conditions => range)
  end
  

end
