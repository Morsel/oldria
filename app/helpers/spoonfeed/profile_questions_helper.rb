module Spoonfeed::ProfileQuestionsHelper

  def btl_description_for_fb(answers)
    output = []
    unless answers.nil?
      answers.first(5).each do |answer|
        output << truncate(answer.answer, :length => 25)
      end
    end
    output.join(' | ')
  end

end
