class MediaRequestsController < ApplicationController
  def show
    @media_request = MediaRequest.find(params[:id])
  end

  def new
    @sender = current_user
    @search = Employment.search(params[:search])
    if params[:search]
      @employments = @search.all(:include => [:restaurant])
      @restaurants = @employments.map(&:restaurant).uniq
      @media_request = @sender.media_requests.build(:publication => @sender.publication)
    end
  end

  def create
    @media_request = current_user.media_requests.build(params[:media_request])

    if @media_request.save
      redirect_to edit_media_request_path(@media_request)
    else
      render :new
    end
  end

  def edit
    @media_request_types = MediaRequestType.all
    @media_request = MediaRequest.find(params[:id])
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
