class ALaMinuteQuestion < ActiveRecord::Base

  has_many :a_la_minute_answers
  named_scope :restaurants, :conditions => {:kind => "restaurant"}

  def answer_for(restaurant)
    restaurant.a_la_minute_answers.last(:conditions => {:a_la_minute_question_id => id})
  end

  def answers_for(restaurant)
    restaurant.a_la_minute_answers.find(:all, :conditions => {:a_la_minute_question_id => id})
  end
end
