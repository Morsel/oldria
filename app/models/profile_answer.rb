# == Schema Information
# Schema version: 20100910002655
#
# Table name: profile_answers
#
#  id                  :integer         not null, primary key
#  profile_question_id :integer
#  answer              :text
#  created_at          :datetime
#  updated_at          :datetime
#

class ProfileAnswer < ActiveRecord::Base

  belongs_to :profile_question
  
  validates_presence_of :answer

end
