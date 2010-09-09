class EmploymentSearchesController < ApplicationController
  before_filter :require_user

  ##
  # Intended for AJAX updating
  def show
    search_setup
    render :partial => "shared/employment_list"
  end

end
