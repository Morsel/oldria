class MediaRequestsController < ApplicationController

  def index
    # These are always scoped by restaurant!
    @restaurant = Restaurant.find(params[:restaurant_id])
    @media_requests = @restaurant.media_requests.all(:include => [:sender, :conversations_with_comments])
  end

  def show
    @media_request = MediaRequest.find(params[:id])
  end

  def new
    @sender = current_user
    if params[:search] && namelike = params[:search].delete(:restaurant_name_like)
      params[:search][:restaurant_name_like_all] = namelike.split unless namelike.blank?
    end

    @search = Employment.search(params[:search])

    if params[:search]
      @employments = @search.all(:include => [:restaurant])
      @restaurants = @employments.map(&:restaurant).reject(&:blank?).uniq
      @media_request = @sender.media_requests.build(:publication => @sender.publication)
      @search = Employment.search(nil) # reset the form
    end
  end

  def create
    @media_request = current_user.media_requests.build(params[:media_request])

    if @media_request.save
      redirect_to edit_media_request_path(@media_request)
    else
      flash.now[:error] = "Oops! No one would get the media request based on your criteria. Are you sure you checked the boxes? Please retry your search, broadening your criteria if necessary."
      @search = Employment.search(params[:search])
      render :new
    end
  end

  def edit
    @media_request_types = MediaRequestType.all
    @media_request = MediaRequest.find(params[:id])
    @media_request.publication = @media_request.sender.try(:publication)
    @restaurants = @media_request.restaurants
  end

  def update
    @media_request = MediaRequest.find(params[:id])
    @media_request.fill_out
    if @media_request.update_attributes(params[:media_request])
      flash[:notice] = "Thanks! Your media request will be sent shortly!"
      redirect_to @media_request
    else
      render :edit
    end
  end

  def destroy
    @media_request = MediaRequest.find(params[:id])
    @media_request.destroy
    flash[:notice] = "Successfully destroyed media request."
    redirect_to media_requests_url
  end
end
