# == Schema Information
# Schema version: 20100825200638
#
# Table name: question_roles
#
#  id                  :integer         not null, primary key
#  profile_question_id :integer
#  restaurant_role_id  :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class QuestionRole < ActiveRecord::Base

  validates_presence_of :name
  has_and_belongs_to_many :restaurant_roles
  has_and_belongs_to_many :topics
  
end
