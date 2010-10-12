module DirectoryHelper
  
  def title_for_search
    if @specialty
      "<h2>Specialty: #{@specialty.name}</h2>"
    elsif @cuisine
      "<h2>Cuisine: #{@cuisine.name}</h2>"
    end
  end
end
