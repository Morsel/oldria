class TrendQuestionDiscussion < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :trend_question
  acts_as_readable
  acts_as_commentable
  validates_uniqueness_of :restaurant_id, :scope => :trend_question_id


  def message
    [trend_question.subject, trend_question.body].reject(&:blank?).join(": ")
  end

  def inbox_title
    "Trend Question"
  end

  def scheduled_at
    trend_question.scheduled_at
  end

end
