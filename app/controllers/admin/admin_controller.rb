class Admin::AdminController < ApplicationController
  layout 'admin'

  before_filter :require_admin

  def index
  end

  private

  ##
  # Employment saved-search methods
  def search_setup(resource)
    @employment_search = if resource.employment_search
        resource.employment_search
      else
        resource.build_employment_search(:conditions => {})
      end

    @search = @employment_search.employments #searchlogic
    @restaurants_and_employments = @search.all(:include => [:restaurant, :employee]).group_by(&:restaurant)
  end

  def save_search
    if params[:search] && defined?(@employment_search)
      @employment_search.conditions = normalized_search_params
      @employment_search.save
    end
  end

  def normalized_search_params
    normalized = params[:search].reject{|k,v| v.blank? }
    normalized.blank? ? {:id => ""} : normalized
  end
end
