class EmploymentSearchesController < Admin::AdminController
  ##
  # Intended for AJAX updating
  def show
    search_setup
    render :partial => "admin/trend_questions/employment_list"
  end

  private
  def search_setup
    @search = Employment.search(params[:search])
    @restaurants_and_employments = @search.all(:include => [:restaurant, :employee]).group_by(&:restaurant)
  end
end
