class SearchesController < ApplicationController
  def show
    @search = User.search(params[:search])
    if params[:search]
      @users = @search.all
      if @users.blank?
        flash.now[:notice] = "Sorry, we came up empty-handed. Doesn’t look like there’s anyone on Spoonfeed that fit your search criteria."
        @search = User.search(nil) # blank out search form
      end
    else
      # TODO helpful message about how to search
    end
    if current_user.has_role?(:media)
      render :mediashow #otherwise render show.html
    end
  end
end
