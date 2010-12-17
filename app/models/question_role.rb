# == Schema Information
# Schema version: 20101207221226
#
# Table name: question_roles
#
#  id                  :integer         not null, primary key
#  profile_question_id :integer
#  responder_id        :integer
#  created_at          :datetime
#  updated_at          :datetime
#  responder_type      :string(255)
#

class QuestionRole < ActiveRecord::Base

  belongs_to :profile_question
  belongs_to :responder, :polymorphic => true

end
