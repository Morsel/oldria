class Admin::MediaRequestsController < Admin::AdminController

  # GET /admin/media_requests
  def index
    @media_requests = MediaRequest.find(:all, :include => :media_request_conversations, :order => "id DESC")
    @approved_media_requests = @media_requests.select(&:approved?)
    @pending_media_requests = @media_requests.select(&:pending?)
  end

  # GET /admin/media_requests/1
  def show
    @media_request = MediaRequest.find(params[:id], :include => {:recipients => [:employee, :restaurant, :restaurant_role]})
  end

  # GET /admin/media_requests/1/edit
  def edit
    @media_request = MediaRequest.find(params[:id])
    @media_request_types = MediaRequestType.all
  end

  # PUT /admin/media_requests/1
  def update
    @media_request_types = MediaRequestType.all
    @media_request = MediaRequest.find(params[:id])
    if @media_request.update_attributes(params[:media_request])
      flash[:success] = "Successfully updated the media request"
      redirect_to admin_media_requests_path
    else
      render :edit
    end
  end

  # PUT /admin/media_requests/1/approve
  def approve
    @media_request = MediaRequest.find(params[:id])
    if @media_request.approve!
      flash[:success] = "Successfully approved that message. A notice will be sent to the recipients."
      redirect_to admin_media_requests_path
    else
      flash[:error] = "We were unable to approve that message."
      redirect_to admin_media_requests_path
    end
  end
end
