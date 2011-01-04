module DirectoryHelper
  
  def title_for_search
    if @specialty
      "<h2>Specialty: #{@specialty.name}</h2>"
    elsif @cuisine
      "<h2>Cuisine: #{@cuisine.name}</h2>"
    end
  end
  
  def users_for_search
    if on_soapbox || on_mediafeed
      User.in_soapbox_directory
    else
      User.in_spoonfeed_directory
    end
  end
  
  def restaurants_for_search
    users_for_search.map(&:restaurants).flatten.compact.uniq.sort_by(&:sort_name)
  end
  
  def restaurant_names_for_search
    (restaurants_for_search.map(&:name) + 
        users_for_search.map(&:default_employment).compact.map(&:solo_restaurant_name).reject(&:blank?)).uniq.sort
  end
  
  def cuisines_for_search
    (users_for_search.map(&:cuisines) + restaurants_for_search.map(&:cuisine)).flatten.compact.uniq.sort_by(&:name)
  end
  
  def specialties_for_search
    users_for_search.map(&:specialties).flatten.compact.uniq.sort_by(&:name)
  end
  
  def roles_for_search
    users_for_search.map(&:all_restaurant_roles).flatten.compact.uniq.sort_by(&:name)
  end
  
  def regions_for_search
    (users_for_search.map(&:james_beard_region) + restaurants_for_search.map(&:james_beard_region)).flatten.compact.uniq.sort_by(&:name)
  end
  
  def metros_for_search
    (users_for_search.map(&:metropolitan_area) + restaurants_for_search.map(&:metropolitan_area)).flatten.compact.uniq.sort_by(&:name)
  end
  
  def correct_restaurant_directory_path
    soapbox? ? soapbox_restaurant_directory_path : restaurant_directory_path
  end
  
  def correct_profile_directory_path
    soapbox? ? soapbox_directory_path : directory_path
  end
  
  def correct_restaurant_path restaurant
    soapbox? ? soapbox_restaurant_path(restaurant) : restaurants_path(restaurant)
  end
end
