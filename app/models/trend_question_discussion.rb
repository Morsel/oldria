class TrendQuestionDiscussion < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :trend_question

  validates_uniqueness_of :restaurant_id, :scope => :trend_question_id
end
