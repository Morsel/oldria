# == Schema Information
# Schema version: 20120217190417
#
# Table name: solo_media_discussions
#
#  id               :integer         not null, primary key
#  media_request_id :integer
#  employment_id    :integer
#  comments_count   :integer         default(0)
#  created_at       :datetime
#  updated_at       :datetime
#

class SoloMediaDiscussion < ActiveRecord::Base

  acts_as_readable
  acts_as_commentable

  belongs_to :media_request
  belongs_to :employment
  
  default_scope :order => "#{table_name}.created_at DESC"

  scope :approved, :joins => :media_request, :conditions => ['media_requests.status = ?', 'approved']
  scope :with_comments, :conditions => "#{table_name}.comments_count > 0"

  def viewable_by?(_employment)
    _employment == employment
  end
  
  def employee
    employment.try(:employee)
  end

  # for comment notifications
  def users
    [employee, media_request.sender]
  end

  def publication_string
    media_request.publication_string
  end

  def email_title
    "Media Request"
  end

  def message
    "#{publication_string} has a question for #{recipient_name}"
  end

  def notify_recipients
    UserMailer.media_request_notification(self, employment.employee).deliver
  end
  
  def recipient_name
    employee.try(:name)
  end

end
