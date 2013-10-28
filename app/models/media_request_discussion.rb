# == Schema Information
#
# Table name: media_request_discussions
#
#  id               :integer         not null, primary key
#  media_request_id :integer
#  restaurant_id    :integer
#  comments_count   :integer         default(0)
#  created_at       :datetime
#  updated_at       :datetime
#

class MediaRequestDiscussion < ActiveRecord::Base

  acts_as_readable
  acts_as_commentable

  belongs_to :media_request
  belongs_to :restaurant
  
  default_scope :order => "#{table_name}.created_at DESC"
  
  scope :approved, :joins => :media_request, :conditions => ['media_requests.status = ?', 'approved']
  scope :with_comments, :conditions => "#{table_name}.comments_count > 0"

  def employments
    restaurant.employments.select { |e| self.viewable_by?(e) }
  end

  def employment_ids
    employments.map(&:id)
  end

  # for comment notifications
  def users
    employments.map(&:employee) + [media_request.sender]
  end

  def viewable_by?(employment)
    return false unless employment
    employment.employee == employment.restaurant.try(:manager) ||
      employment.omniscient? ||
      media_request.employment_search.employments.relation.include?(employment)
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
    employments.each do |employment|
      UserMailer.media_request_notification(self, employment.employee).deliver
    end
  end
  
  def recipient_name
    restaurant.try(:name)
  end

end
