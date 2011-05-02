class Soapbox::ALaMinuteQuestionsController < ApplicationController

  def index
    # ALM Questions with a publicly-viewable answer from a premium user
    @questions = ALaMinuteQuestion.all(:joins => 'INNER JOIN a_la_minute_answers
                                                  ON `a_la_minute_answers`.a_la_minute_question_id = `a_la_minute_questions`.id
                                                  INNER JOIN subscriptions
                                                  ON `subscriptions`.subscriber_id = `a_la_minute_answers`.responder_id
                                                  AND `subscriptions`.subscriber_type = `a_la_minute_answers`.responder_type',
                                       :order => "a_la_minute_answers.created_at DESC",
                                       :select => "DISTINCT `a_la_minute_questions`.*",
                                       :conditions => ["`a_la_minute_answers`.show_as_public = ?
                                                        AND subscriptions.id IS NOT NULL
                                                        AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
                                                        true, Date.today])[0...10]
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

  def show
    @question = ALaMinuteQuestion.find(params[:id])
    @answers = ALaMinuteAnswer.from_premium_responders.show_public.newest_for(@question)
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

end