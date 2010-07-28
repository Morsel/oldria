class EmploymentSearchesController < ApplicationController
  before_filter :require_user

  ##
  # Intended for AJAX updating
  def show
    search_setup
    render :partial => "shared/employment_list"
  end

  def add_user
    users = User.for_autocomplete.find_all_by_name(params[:employee])
    
    # if previous_user_list = params[:search].delete(:employee_id_equals_any)
    #   users += User.find(previous_user_list)
    # end

    render :update do |page|
      page.replace_html 'employee-list', :partial => 'shared/search_user_selection', :collection => users, :as => :user
      page.call 'updateEmploymentsList'
    end unless users.blank?
  end

end
