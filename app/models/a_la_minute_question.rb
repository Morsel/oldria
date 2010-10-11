class ALaMinuteQuestion < ActiveRecord::Base

  KINDS = %w(restaurant user)

  has_many :a_la_minute_answers

  validates_inclusion_of :kind, :in => KINDS

  # named_scope :restaurants, :conditions => {:kind => "restaurant"}
  KINDS.each do |kind|
    named_scope :"#{kind.pluralize}", :conditions => {:kind => kind}
  end


  def answer_for(restaurant)
    restaurant.a_la_minute_answers.last(:conditions => {:a_la_minute_question_id => id})
  end

  def answers_for(restaurant)
    restaurant.a_la_minute_answers.find(:all, :conditions => {:a_la_minute_question_id => id})
  end
end
