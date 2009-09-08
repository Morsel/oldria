class SearchesController < ApplicationController
  def show
    @search = User.search(params[:search])
    if params[:search]
      un = params[:search][:username] || ''
      @users = User.username_or_first_name_or_last_name_like(un)
    end
  end
end
