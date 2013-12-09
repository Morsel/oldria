# == Schema Information
#
# Table name: admin_discussions
#
#  id                  :integer         not null, primary key
#  restaurant_id       :integer
#  discussionable_id   :integer
#  created_at          :datetime
#  updated_at          :datetime
#  comments_count      :integer         default(0)
#  discussionable_type :string(255)
#

class AdminDiscussion < ActiveRecord::Base

  belongs_to :restaurant
  belongs_to :discussionable, :polymorphic => true

  acts_as_readable
  acts_as_commentable

  validates_uniqueness_of :restaurant_id, :scope => [:discussionable_id, :discussionable_type]

  scope :with_replies, :conditions => "#{table_name}.comments_count > 0"
  scope :without_replies, :conditions => "#{table_name}.comments_count = 0"
  
  scope :for_trends, :conditions => { :discussionable_type => "TrendQuestion" }
  scope :for_content_requests, :conditions => { :discussionable_type => "ContentRequest" }
  attr_accessible :restaurant, :discussionable
  def message
    [discussionable.subject, discussionable.body].reject(&:blank?).join(": ")
  end

  def display_message
    discussionable.display_message
  end

  def inbox_title
    discussionable.class.title
  end

  def email_title
    inbox_title
  end

  def email_body
    message
  end

  def short_title
    "rd"
  end

  def scheduled_at
    discussionable.scheduled_at
  end

  def soapbox_entry
    discussionable.soapbox_entry
  end

  def employments
    # Only include the employments that match the employment search criteria
    restaurant.employments.all(:include => :employee) & discussionable.employment_search.try(:employments).try(:all, :include => :employee)
  end

  def employees
    @employees ||= employments.map(&:employee)
  end

  def viewable_by?(employment)
    discussionable.viewable_by?(employment)
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
    self.send_at(scheduled_at, :send_email_notification_to_each_employee)
  end

  def send_email_notification_to_each_employee
    employments.each do |employment|
      if employment.employee.prefers_receive_email_notifications && employment.prefers_receive_email_notifications # For employment basis email sending 
        UserMailer.send("deliver_#{discussionable.mailer_method}", self, employment.employee)
      end
    end
  end
  
end
