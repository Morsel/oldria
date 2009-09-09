class SearchesController < ApplicationController
  def show
    @search = User.search(params[:search])
    if params[:search]
      @users = @search.all
      flash.now[:notice] = "We couldn't find anything" if @users.blank?
    else
      # TODO helpful message about how to search
    end
  end
end
