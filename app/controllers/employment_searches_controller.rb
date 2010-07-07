class EmploymentSearchesController < Admin::AdminController
  ##
  # Intended for AJAX updating
  def show
    search_setup
    render :partial => "shared/employment_list"
  end

  private
  def search_setup
    @search = Employment.search(params[:search])
    @restaurants_and_employments = @search.all(:include => [:restaurant, :employee]).uniq.group_by(&:restaurant)
  end
end
