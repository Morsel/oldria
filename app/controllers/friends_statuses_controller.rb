class FriendsStatusesController < ApplicationController
  before_filter :require_user

  def show
    @statuses = Status.friends_of_user(current_user).paginate(:page => params[:page], :per_page => 20)
  end
end
