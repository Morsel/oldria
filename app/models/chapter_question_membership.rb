class ChapterQuestionMembership < ActiveRecord::Base
  
  belongs_to :chapter
  belongs_to :profile_question

end
