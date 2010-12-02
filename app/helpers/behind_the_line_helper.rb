module BehindTheLineHelper
  def find_answer_for(question, subject)
    if subject.is_a? RestaurantFeaturePage
      subject = Restaurant.find(params[:restaurant_id])
    end
    question.find_or_build_answer_for(subject)
  end

  def link_for_chapter(options = {})
    subject = options.delete(:subject)
    options = options_for_subject(subject, options)
    path_model_name = path_model_name(subject)

    if params[:controller].match(/soapbox/)
      send("chapters_soapbox_#{path_model_name}_questions_path".to_sym, options)
    else
      send("chapters_#{path_model_name}_questions_path", options)
    end
  end

  def link_for_topics(options = {})
    subject = options.delete(:subject)
    options = options_for_subject(subject, options)
    path_model_name = path_model_name(subject)

    if params[:controller].match(/soapbox/)
      send("topics_soapbox_#{path_model_name}_questions_path", options)
    else
      send("topics_#{path_model_name}_questions_path", options)
    end
  end

  def link_for_questions(options = {})
    subject = options.delete(:subject)
    options = options_for_subject(subject, options)
    path_model_name = path_model_name(subject)

    if params[:controller].match(/soapbox/)
      send("soapbox_#{path_model_name}_questions_path", options)
    else
      send("#{path_model_name}_questions_path", options)
    end
  end

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

    if params[:controller].match(/soapbox/)
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

  def answer_for(subject, question)
    subject.is_a?(RestaurantFeaturePage) ?
      question.answer_for(Restaurant.find(params[:restaurant_id])) :
      question.answer_for(subject)
  end

  def completion_percentage_for(subject, obj)
    secondary_subject = subject.is_a?(RestaurantFeaturePage) ? Restaurant.find(params[:restaurant_id]) : nil
    obj.completion_percentage(subject, secondary_subject)
  end

  def answer_count_for(subject, obj)
    secondary_subject = subject.is_a?(RestaurantFeaturePage) ? Restaurant.find(params[:restaurant_id]) : nil
    obj.answer_count_for_subject(subject, secondary_subject)
  end

  def question_count_for(subject, obj)
    secondary_subject = subject.is_a?(RestaurantFeaturePage) ? Restaurant.find(params[:restaurant_id]) : nil
    obj.question_count_for_subject(subject)
  end

  def published_for(subject, obj)
    secondary_subject = subject.is_a?(RestaurantFeaturePage) ? Restaurant.find(params[:restaurant_id]) : nil
    obj.published?(subject, secondary_subject)
  end

  private
  def path_model_name(model)
    if model.is_a?(RestaurantFeaturePage)
      if params[:controller].match(/soapbox/)
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