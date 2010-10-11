class ALaMinuteAnswer < ActiveRecord::Base
  belongs_to :a_la_minute_question
  belongs_to :responder, :polymorphic => true

  validates_presence_of :a_la_minute_question_id

  default_scope :order => 'created_at desc', :include => :a_la_minute_question
  named_scope :newest, :group => :a_la_minute_question_id, :order => 'created_at desc'

  def self.public_profile_for(responder)
    responder.a_la_minute_answers.find_all_by_show_as_public(true,
        :group => :a_la_minute_question_id,
        :order => "created_at desc",
        :limit => 3)
  end

  before_create :set_show_as_public_flag

  private
  def set_show_as_public_flag
    return true unless responder
    previous_answer = a_la_minute_question.answer_for(responder)
    self.show_as_public = previous_answer.show_as_public if previous_answer
  end
end
