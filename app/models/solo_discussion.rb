# == Schema Information
# Schema version: 20120217190417
#
# Table name: solo_discussions
#
#  id                :integer         not null, primary key
#  employment_id     :integer
#  trend_question_id :integer
#  comments_count    :integer         default(0)
#  created_at        :datetime
#  updated_at        :datetime
#

class SoloDiscussion < ActiveRecord::Base
  
  belongs_to :trend_question
  belongs_to :employment
  
  validates_uniqueness_of :employment_id, :scope => :trend_question_id
  
  acts_as_readable
  acts_as_commentable
  
  scope :with_replies, :conditions => "#{table_name}.comments_count > 0"
  scope :without_replies, :conditions => "#{table_name}.comments_count = 0"
  
  scope :current, lambda {
    { :joins => :trend_question,
      :conditions => ['trend_questions.scheduled_at < ? OR trend_questions.scheduled_at IS NULL', Time.zone.now],
      :order => 'trend_questions.scheduled_at DESC'  }
  }

  scope :recent, lambda {
    { :conditions => ['trend_questions.scheduled_at >= ?', 2.weeks.ago] }
  }

  def message
    [trend_question.subject, trend_question.body].reject(&:blank?).join(": ")
  end

  def display_message
    trend_question.display_message
  end

  def inbox_title
    trend_question.class.title
  end

  def email_title
    inbox_title
  end

  def email_body
    message
  end

  def short_title
    "sd"
  end

  def scheduled_at
    trend_question.scheduled_at
  end

  def soapbox_entry
    trend_question.soapbox_entry
  end
  
  def employee
    employment.try(:employee)
  end
  
  def recipients_can_reply?
    true
  end
  
  def create_response_for_user(user, comment)
    self.comments.create(:user => user, :comment => comment)
  end

  ##
  # Should only be called from an external observer.
  def notify_recipients
    self.send_at(scheduled_at, :send_email_notification) if employment.prefers_receive_email_notifications # For employment basis email sending 
  end

  def send_email_notification
    UserMailer.answerable_message_notification(self, employee).deliver if employee.prefers_receive_email_notifications
  end

end
