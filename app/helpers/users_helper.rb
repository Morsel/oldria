module UsersHelper

  def media_or_owner?
    return false unless current_user
    (current_user == @user) || current_user.media?
  end

  def media?
    return false unless current_user
    current_user.media?
  end

  def already_following?(follower)
    return true unless current_user
    (current_user == follower) || current_user.following?(follower)
  end

  def primary?(employment)
    employment == current_user.primary_employment
  end

  def display_email(user)
    return false unless user.profile
    if user.profile.prefers_display_email == "everyone"
      true
    elsif current_user && user.profile.prefers_display_email == "spoonfeed"
      true
    else
      false
    end
  end

  def display_cell(user)
    return false unless user.profile && user.profile.cellnumber.present?
    if user.profile.prefers_display_cell == "everyone"
      true
    elsif current_user && user.profile.prefers_display_cell == "spoonfeed"
      true
    else
      false
    end
  end

  def display_twitter(user)
    return false unless user.profile && user.twitter_username.present?
    if user.profile.prefers_display_twitter == "everyone"
      true
    elsif current_user && user.profile.prefers_display_twitter == "spoonfeed"
      true
    else
      false
    end
  end

  def display_facebook(user)
    return false unless user.profile

    if user.facebook_user
      user.facebook_user.fetch
    else
      return false
    end

    if user.profile.prefers_display_facebook == "everyone"
      true
    elsif current_user && user.profile.prefers_display_facebook == "spoonfeed"
      true
    else
      false
    end
  rescue Exception
    false
  end

  def directory_link(user)
    params[:controller].match(/soapbox/) ? soapbox_profile_path(user.username) : profile_path(user.username)
  end

  def directory_search_link(options = {})
    params[:controller].match(/soapbox/) ? soapbox_directory_path(options) : directory_path(options)
  end

  def link_for_chapter(options = {})
    subject = options.delete(:subject)
    if subject.is_a? RestaurantFeaturePage
      options.merge!({:restaurant_id => params[:restaurant_id]})
      options.merge!({:feature_page_id => subject.id})
    else
      options.merge!({"#{subject.class.name.underscore}_id".to_sym => subject.id})
    end
    puts "options => #{options.inspect}"
    if params[:controller].match(/soapbox/)
      send("chapters_soapbox_#{subject.class.name.underscore}_questions_path".to_sym, options)
    else
      send("chapters_#{subject.class.name.underscore}_questions_path", options)
    end
  end

  def link_for_topics(options = {})
    subject = options.delete(:subject)
    if subject.is_a? RestaurantFeaturePage
      options.merge!({:restaurant_id => params[:restaurant_id]})
      options.merge!({:feature_page_id => subject.id})
    else
      options.merge!({"#{subject.class.name.underscore}_id".to_sym => subject.id})
    end
    if params[:controller].match(/soapbox/)
      send("topics_soapbox_#{subject.class.name.underscore}_questions_path", options)
    else
      send("topics_#{subject.class.name.underscore}_questions_path", options)
    end
  end

  def link_for_questions(options = {})
    subject = options.delete(:subject)
    if subject.is_a? RestaurantFeaturePage
      options.merge!({:restaurant_id => params[:restaurant_id]})
      options.merge!({:feature_page_id => subject.id})
    else
      options.merge!({"#{subject.class.name.underscore}_id".to_sym => subject.id})
    end
    if params[:controller].match(/soapbox/)
      send("soapbox_#{subject.class.name.underscore}_questions_path", options)
    else
      send("#{subject.class.name.underscore}_questions_path", options)
    end
  end

  def link_for_question(options = {})
    if params[:controller].match(/soapbox/)
      soapbox_question_path(options)
    else
      question_path(options)
    end
  end

end
