# == Schema Information
# Schema version: 20110913204942
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
#  show_as_public          :boolean
#

class ALaMinuteAnswer < ActiveRecord::Base
  belongs_to :a_la_minute_question
  belongs_to :responder, :polymorphic => true

  validates_presence_of :a_la_minute_question_id
  validates_presence_of :answer

  default_scope :order => 'created_at desc', :include => :a_la_minute_question

  named_scope :for_question, lambda { |question| {:conditions => {:a_la_minute_question_id => question.id}} }
  named_scope :show_public, :conditions => { :show_as_public => true }

  named_scope :from_premium_responders, lambda {
    {
      :joins => 'INNER JOIN subscriptions ON `subscriptions`.subscriber_id = responder_id AND `subscriptions`.subscriber_type = responder_type',
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today]
    }
  }

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
    ids = responder.a_la_minute_answers.maximum(:created_at, :group => :a_la_minute_question_id, :select => :id, :conditions => { :show_as_public => true }).collect{|k,v|v}
    responder.a_la_minute_answers.find(ids, :order => "created_at desc")
  end

  def self.archived_for(question)
    answers = self.for_question(question)
    answers.shift
    answers
  end

  attr_writer :old_answer
  def old_answer
    @old_answer || answer
  end
end
