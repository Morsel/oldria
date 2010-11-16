module DirectoryHelper
  
  def title_for_search
    if @specialty
      "<h2>Specialty: #{@specialty.name}</h2>"
    elsif @cuisine
      "<h2>Cuisine: #{@cuisine.name}</h2>"
    end
  end
  
  def users_for_search
    if on_soapbox
      User.in_soapbox_directory
    else
      User.in_spoonfeed_directory
    end
  end
  
  def restaurants_for_search
    users_for_search.map(&:restaurants).flatten.compact.uniq.sort_by(&:sort_name)
  end
  
  def cuisines_for_search
    (Cuisine.with_profiles + Cuisine.with_restaurants).uniq.sort_by(&:name)
  end
  
  def regions_for_search
    (JamesBeardRegion.with_profiles + JamesBeardRegion.with_restaurants).uniq.sort_by(&:name)
  end
  
  def metros_for_search
    (MetropolitanArea.with_profiles + MetropolitanArea.with_restaurants).uniq.sort_by(&:name)
  end
end
