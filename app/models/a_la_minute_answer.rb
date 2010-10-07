class ALaMinuteAnswer < ActiveRecord::Base
  belongs_to :a_la_minute_question
  belongs_to :responder, :polymorphic => true
end
