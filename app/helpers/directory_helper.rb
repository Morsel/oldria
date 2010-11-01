module DirectoryHelper
  
  def title_for_search
    if @specialty
      "<h2>Specialty: #{@specialty.name}</h2>"
    elsif @cuisine
      "<h2>Cuisine: #{@cuisine.name}</h2>"
    end
  end
  
  def cuisines_for_search
    (Cuisine.with_profiles + Cuisine.with_restaurants).uniq.sort_by(&:name)
  end
  
  def regions_for_search
    (JamesBeardRegion.with_profiles + JamesBeardRegion.with_restaurants).uniq.sort_by(&:name)
  end
end
