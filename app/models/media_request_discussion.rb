# == Schema Information
# Schema version: 20100708221553
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
  acts_as_commentable
  belongs_to :media_request
  belongs_to :restaurant

  def employments
    restaurant.employments.handling_subject_matter_id(subject_matter_id)
  end

  def subject_matter_id
    media_request.subject_matter_id
  end

  def employment_ids
    employments.map(&:id)
  end

  def viewable_by?(employment)
    employments.include?(employment)
  end

end
