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
    Employment.find(employment_ids)
  end

  # Employments are only those who are both a part of this discussion's restaurant
  # and also part of the search criteria
  def employment_ids
    (media_request.employment_ids & restaurant.employment_ids).uniq
  end

  def viewable_by?(employment)
    media_request.viewable_by?(employment)
  end

end
