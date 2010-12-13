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

  belongs_to :profile_question
  belongs_to :responder, :polymorphic => true

end
