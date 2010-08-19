# == Schema Information
# Schema version: 20100819192128
#
# Table name: chapter_question_memberships
#
#  id                  :integer         not null, primary key
#  chapter_id          :integer
#  profile_question_id :integer
#  position            :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class ChapterQuestionMembership < ActiveRecord::Base
  
  belongs_to :chapter
  belongs_to :profile_question

end
