class SoloDiscussion < ActiveRecord::Base
  
  belongs_to :trend_question
  belongs_to :employment
  
  validates_uniqueness_of :employment_id, :scope => :trend_question_id
  
  acts_as_readable
  acts_as_commentable
  
  named_scope :with_replies, :conditions => "#{table_name}.comments_count > 0"
  named_scope :without_replies, :conditions => "#{table_name}.comments_count = 0"
  
  named_scope :current, lambda {
    { :joins => :trend_question,
      :conditions => ['trend_questions.scheduled_at < ? OR trend_questions.scheduled_at IS NULL', Time.zone.now],
      :order => 'trend_questions.scheduled_at DESC'  }
    }

  def message
    [trend_question.subject, trend_question.body].reject(&:blank?).join(": ")
  end

  def inbox_title
    trend_question.class.title
  end

  def email_title
    inbox_title
  end

  def scheduled_at
    trend_question.scheduled_at
  end

  def soapbox_entry
    trend_question.soapbox_entry
  end
  
  def employee
    employment.employee
  end
  
  def recipients_can_reply?
    true
  end

end
