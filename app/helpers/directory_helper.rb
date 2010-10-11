module DirectoryHelper
  
  def title_for_search
    if params[:specialty_id]
      "<h2>Specialty: #{@specialty.name}</h2>"
    end
  end
end
