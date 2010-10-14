# == Schema Information
#
# Table name: a_la_minute_questions
#
#  id         :integer         not null, primary key
#  question   :text
#  kind       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ALaMinuteQuestion < ActiveRecord::Base

  KINDS = %w(restaurant user)

  has_many :a_la_minute_answers, :dependent => :destroy

  validates_inclusion_of :kind, :in => KINDS

  attr_accessor :show_as_public

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
