module QuestionsHelper

  def btl_description_for_fb(answers)
    output = []
    unless answers.nil?
      answers.first(5).each do |answer|
        output << truncate(answer.answer, :length => 25)
      end
    end
    output.join(' | ')
  end
  
  def find_btl_url_for(subject)
    if subject.is_a?(User)
      if logged_in_on_spoonfeed
        profile_path(subject.username)
      elsif subject.premium_account
        soapbox_profile_path(subject.username)
        # No url for non-premium accounts because we shouldn't see them off spoonfeed
      end
    elsif subject.is_a?(Restaurant)
      if logged_in_on_spoonfeed
        restaurant_url(subject)
      elsif subject.premium_account
        soapbox_restaurant_path(subject)
      end
    end
  end
end
