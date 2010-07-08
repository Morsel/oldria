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
end
