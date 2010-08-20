class QuestionRole < ActiveRecord::Base

  belongs_to :profile_question
  belongs_to :restaurant_role
  
end
