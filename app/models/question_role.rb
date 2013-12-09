# == Schema Information
# Schema version: 20120217190417
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

  belongs_to :profile_question
  belongs_to :restaurant_role
  attr_accessible :profile_question_id, :restaurant_role_id
end
