class ALaMinuteAnswer < ActiveRecord::Base
  belongs_to :a_la_minute_question
  belongs_to :responder, :polymorphic => true

  default_scope :order => 'created_at asc', :include => :a_la_minute_question
  named_scope :newest, :group => :a_la_minute_question_id, :order => 'created_at asc'
end
