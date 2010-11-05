module ALaMinuteAnswersHelper
  def answer_for(question)
    answer = if params[:a_la_minute_questions] && params[:a_la_minute_questions]["#{question.id}"]
      ALaMinuteAnswer.new(params[:a_la_minute_questions]["#{question.id}"])
    else
      question.answer_for(@restaurant) || ALaMinuteAnswer.new
    end
  end
end