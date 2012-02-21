# == Schema Information
# Schema version: 20120217190417
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
# Indexes
#
#  admin_discussions_by_discussionable       (discussionable_id,discussionable_type)
#  index_admin_discussions_on_restaurant_id  (restaurant_id)
#

class AdminDiscussion < ActiveRecord::Base

  belongs_to :restaurant
  belongs_to :discussionable, :polymorphic => true

  acts_as_readable
  acts_as_commentable

  validates_uniqueness_of :restaurant_id, :scope => [:discussionable_id, :discussionable_type]

  named_scope :with_replies, :conditions => "#{table_name}.comments_count > 0"
  named_scope :without_replies, :conditions => "#{table_name}.comments_count = 0"
  
  named_scope :for_trends, :conditions => { :discussionable_type => "TrendQuestion" }
  named_scope :for_content_requests, :conditions => { :discussionable_type => "ContentRequest" }
  
  def message
    [discussionable.subject, discussionable.body].reject(&:blank?).join(": ")
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
    employees.each do |user|
      if user.prefers_receive_email_notifications
        UserMailer.send("deliver_#{discussionable.mailer_method}", self, user)
      end
    end
  end
  
end
