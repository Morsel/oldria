class SearchesController < ApplicationController
  def show
    @search = User.search(params[:search])
    if params[:search]
      @users = @search.all
      flash.now[:notice] = "Sorry, we came up empty-handed. Doesn’t look like there’s anyone on Spoonfeed that fit your search criteria." if @users.blank?
    else
      # TODO helpful message about how to search
    end
    if current_user.has_role?(:media)
      render :mediashow
    else
      # render 'show.html'
    end
  end
end
