module RestaurantsHelper
  def restaurant_link(restaurant, options = nil)
    link_to_if (restaurant.linkable_profile? || logged_in_on_spoonfeed),
               restaurant.try(:name),
               correct_restaurant_path(restaurant),
               options
  end

  def restaurant_link_for_media(restaurant, options = nil)
    link_to_if (restaurant.linkable_profile? || logged_in_on_spoonfeed_for_media),
               restaurant.try(:name),
               correct_restaurant_path(restaurant),
               options
  end   

  def restaurant_names_for_user(user)
    if user.employments.blank?
      user.primary_employment.try(:solo_restaurant_name) unless user.primary_employment.blank?
    elsif user.employments.count == 1
      restaurant_link(user.primary_employment.restaurant)
    elsif user.employments.count <= 3
      sorted_employments = ([user.primary_employment] + user.nonprimary_employments).flatten
      sorted_employments.map { |e| restaurant_link(e.restaurant) }.to_sentence
    else
      sorted_employments = ([user.primary_employment] + user.nonprimary_employments[0..1]).flatten
      sorted_employments = sorted_employments.map { |e| restaurant_link(e.restaurant) }
      sorted_employments.join(", ") + " and #{link_to 'more', profile_path(user.username)}".html_safe 
    end
  end

  def restaurant_names_for_media_user(user)
    if user.employments.blank?
      user.primary_employment.try(:solo_restaurant_name)
    elsif user.employments.count == 1
      restaurant_link_for_media(user.primary_employment.restaurant)
    elsif user.employments.count <= 3
      sorted_employments = ([user.primary_employment] + user.nonprimary_employments).flatten
      sorted_employments.map { |e| restaurant_link_for_media(e.restaurant) }.to_sentence
    else
      sorted_employments = ([user.primary_employment] + user.nonprimary_employments[0..1]).flatten
      sorted_employments = sorted_employments.map { |e| restaurant_link_for_media(e.restaurant) }
      sorted_employments.join(", ") + " and #{link_to 'more', profile_path(user.username)}".html_safe 
    end
  end
  
  
  def correct_restaurant_photos_path restaurant
     soapbox? ? soapbox_restaurant_photos_path(restaurant) : restaurant_photos_path(restaurant)
  end

  def link_for_restaurant_topics(opts = {})
    if soapbox?
      topics_soapbox_restaurant_questions_path(opts)
    else
      restaurant_behind_the_line_path(opts)
    end
  end

  def link_for_restaurant_chapters(opts = {})
    if soapbox?
      chapters_soapbox_restaurant_questions_path(opts)
    else
      restaurant_btl_topic_path(opts)
    end
  end

  def link_for_restaurant_questions(opts = {})
    if soapbox?
      soapbox_restaurant_questions_path(opts)
    else
      restaurant_btl_chapter_path(opts)
    end
  end

  def restaurant_topics(restaurant, page = nil)
    if can?(:manage, restaurant)
      page.present? ? page.topics : restaurant.topics
    else
      page.present? ? page.published_topics(restaurant) : restaurant.published_topics
    end
  end

  def path_for_restaurant_and_page(restaurant, page = nil)
    if logged_in_on_spoonfeed
      page.present? ? restaurant_feature_page_path(restaurant, page) : restaurant_path(restaurant)
    elsif restaurant.premium_account
      page.present? ? soapbox_restaurant_feature_page_path(restaurant, page) : soapbox_restaurant_path(restaurant)
    else
      # No url for non-premium accounts because we shouldn't see them off spoonfeed
      ""
    end
  end  
  def fb_page_options    
    options = "<select name='facebook_page' id='facebook_page'><option>&nbsp;</option>"
    @fb_pages.each do |page|
      options = options +  "<option value=#{page['id']}>#{page['name']}</option>"
    end
    options = options + "<br><input type=submit value='Save Facebook Page', class = 'clear'>"
    options.html_safe
  end
end
