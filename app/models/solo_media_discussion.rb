# == Schema Information
# Schema version: 20101220214928
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

  acts_as_commentable
  belongs_to :media_request
  belongs_to :employment
  
  default_scope :order => "#{table_name}.created_at DESC"

  named_scope :with_comments, :conditions => "#{table_name}.comments_count > 0"

  def viewable_by?(_employment)
    _employment == employment
  end
  
  def employee
    employment.employee
  end

  def deliver_notifications
    UserMailer.deliver_media_request_notification(self, employment.employee)
  end
  
  def recipient_name
    employee.name
  end

end
