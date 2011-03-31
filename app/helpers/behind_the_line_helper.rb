module BehindTheLineHelper

  def link_for_question(options = {})
    if params[:controller].match(/soapbox/)
      soapbox_question_path(options)
    else
      question_path(options)
    end
  end

  def link_for_profile_answers(options = {})
    subject = options.delete(:subject)
    options = options_for_subject(subject, options)
    path_model_name = path_model_name(subject)

    if soapbox?
      send("soapbox_#{path_model_name}_profile_answers_path", options)
    else
      send("#{path_model_name}_profile_answers_path", options)
    end
  end

  def link_for_profile_answer(answer, options = {})
    subject = options.delete(:subject)
    options.merge!({:id => answer.id})
    options = options_for_subject(subject, options)
    path_model_name = path_model_name(subject)

    if params[:controller].match(/soapbox/)
      send("soapbox_#{path_model_name}_questions_path", options)
    else
      send("#{path_model_name}_profile_answer_path", options)
    end
  end

  private
  def path_model_name(model)
    if model.is_a?(RestaurantFeaturePage)
      if soapbox?
        "restaurant_feature_page"
      else
        "restaurant_feature"
      end
    else
      model.class.name.underscore
    end
  end

  def options_for_subject(subject, options)
    if subject.is_a? RestaurantFeaturePage
      options.merge!(feature_page_params(subject))
    else
      options.merge!({"#{subject.class.name.underscore}_id".to_sym => subject.id})
    end
  end

  def feature_page_params(subject)
    if params[:controller].match(/soapbox/)
      { :restaurant_id => params[:restaurant_id], :feature_page_id => subject.id }
    else
      { :restaurant_id => params[:restaurant_id], :feature_id => subject.id }
    end
  end

end