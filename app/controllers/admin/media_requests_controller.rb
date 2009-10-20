class Admin::MediaRequestsController < Admin::AdminController
  
  def index
    @media_requests = MediaRequest.find(:all, :include => :media_request_conversations)
  end

  def edit
    @media_request = MediaRequest.find(params[:id])
    @media_request_types = MediaRequestType.all
  end

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

end
