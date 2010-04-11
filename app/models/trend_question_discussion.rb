class TrendQuestionDiscussion < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :trend_question
  acts_as_commentable
  validates_uniqueness_of :restaurant_id, :scope => :trend_question_id
end
