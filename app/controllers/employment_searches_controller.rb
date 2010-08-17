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
    
    # collecting previously searched users
    if params[:search] && params[:search].include?('employee_id_equals_any')
      users += User.find(params[:search]['employee_id_equals_any']).to_a
    end

    render :update do |page|
      page.replace_html 'employee-list', :partial => 'shared/search_user_selection', :collection => users, :as => :user
      page.call 'updateEmploymentsList'
    end unless users.blank?
  end
  
  def add_restaurant
    restaurants = Restaurant.find_all_by_name(params[:restaurant])
    
    # collecting previously searched restaurants
    if params[:search] && params[:search].include?('restaurant_id_equals_any')
      restaurants += Restaurant.find(params[:search]['restaurant_id_equals_any']).to_a
    end
    
    render :update do |page|
      page.replace_html 'restaurant-list', :partial => 'shared/search_restaurant_selection', 
        :collection => restaurants, :as => :restaurant
      page.call 'updateEmploymentsList'
    end unless restaurants.blank?
  end

end
