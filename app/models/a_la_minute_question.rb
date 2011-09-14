# == Schema Information
# Schema version: 20110913204942
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

  has_many :a_la_minute_answers, :dependent => :destroy

  validates_presence_of :question
  validates_inclusion_of :kind, :in => KINDS

  named_scope :answered, :joins => :a_la_minute_answers

  # named_scope :restaurants, :conditions => {:kind => "restaurant"}
  KINDS.each do |kind|
    named_scope :"#{kind.pluralize}", :conditions => {:kind => kind}
  end

  def answer_for(restaurant)
    restaurant.a_la_minute_answers.first(:conditions => {:a_la_minute_question_id => id})
  end

  def answers_for(restaurant)
    restaurant.a_la_minute_answers.find(:all, :conditions => {:a_la_minute_question_id => id})
  end

  def latest_answer
    a_la_minute_answers.from_premium_responders.show_public.first
  end

  def self.most_recent_for_soapbox(count = 10)
    all(:joins => 'LEFT OUTER JOIN a_la_minute_answers
                   ON `a_la_minute_answers`.a_la_minute_question_id = `a_la_minute_questions`.id
                   INNER JOIN subscriptions
                   ON `subscriptions`.subscriber_id = `a_la_minute_answers`.responder_id
                   AND `subscriptions`.subscriber_type = `a_la_minute_answers`.responder_type',
        :order => "a_la_minute_answers.created_at DESC",
        :conditions => ["`a_la_minute_answers`.show_as_public = ?
                         AND subscriptions.id IS NOT NULL
                         AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
                         true, Date.today]).uniq[0...count]
  end

end
