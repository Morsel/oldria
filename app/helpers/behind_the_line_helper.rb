module BehindTheLineHelper
  def find_answer_for(question, subject)
    if subject.is_a? RestaurantFeaturePage
      subject = Restaurant.find(params[:restaurant_id])
    end
    question.find_or_build_answer_for(subject)
  end

  def link_for_chapter(options = {})
    subject = options.delete(:subject)
    if subject.is_a? RestaurantFeaturePage
      options.merge!({:restaurant_id => params[:restaurant_id]})
      options.merge!({:feature_id => subject.id})
    else
      options.merge!({"#{subject.class.name.underscore}_id".to_sym => subject.id})
    end

    path_model_name = (subject.is_a? RestaurantFeaturePage) ?
                    "restaurant_feature" : subject.class.name.underscore

    if params[:controller].match(/soapbox/)
      send("chapters_soapbox_#{path_model_name}_questions_path".to_sym, options)
    else
      send("chapters_#{path_model_name}_questions_path", options)
    end
  end

  def link_for_topics(options = {})
    subject = options.delete(:subject)
    if subject.is_a? RestaurantFeaturePage
      options.merge!({:restaurant_id => params[:restaurant_id]})
      options.merge!({:feature_id => subject.id})
    else
      options.merge!({"#{subject.class.name.underscore}_id".to_sym => subject.id})
    end

    path_model_name = (subject.is_a? RestaurantFeaturePage) ?
                    "restaurant_feature" : subject.class.name.underscore

    if params[:controller].match(/soapbox/)
      send("topics_soapbox_#{path_model_name}_questions_path", options)
    else
      send("topics_#{path_model_name}_questions_path", options)
    end
  end

  def link_for_questions(options = {})
    subject = options.delete(:subject)
    if subject.is_a? RestaurantFeaturePage
      options.merge!({:restaurant_id => params[:restaurant_id]})
      options.merge!({:feature_id => subject.id})
    else
      options.merge!({"#{subject.class.name.underscore}_id".to_sym => subject.id})
    end

    path_model_name = (subject.is_a? RestaurantFeaturePage) ?
                    "restaurant_feature" : subject.class.name.underscore

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
    if subject.is_a? RestaurantFeaturePage
      options.merge!({:restaurant_id => params[:restaurant_id]})
      options.merge!({:feature_id => subject.id})
    else
      options.merge!({"#{subject.class.name.underscore}_id".to_sym => subject.id})
    end

    path_model_name = (subject.is_a? RestaurantFeaturePage) ?
                    "restaurant_feature" : subject.class.name.underscore

    if params[:controller].match(/soapbox/)
      send("soapbox_#{path_model_name}_profile_answers_path", options)
    else
      send("#{path_model_name}_profile_answers_path", options)
    end
  end

  def link_for_profile_answer(answer, options = {})
    subject = options.delete(:subject)
    if subject.is_a? RestaurantFeaturePage
      options.merge!({:restaurant_id => params[:restaurant_id]})
      options.merge!({:feature_id => subject.id})
    else
      options.merge!({"#{subject.class.name.underscore}_id".to_sym => subject.id})
    end
    options.merge!({:id => answer.id})

    path_model_name = (subject.is_a? RestaurantFeaturePage) ?
                    "restaurant_feature" : subject.class.name.underscore

    if params[:controller].match(/soapbox/)
      send("soapbox_#{path_model_name}_questions_path", options)
    else
      send("#{path_model_name}_profile_answer_path", options)
    end
  end
end