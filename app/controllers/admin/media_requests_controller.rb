class Admin::MediaRequestsController < Admin::AdminController
  
  def index
    @media_requests = MediaRequest.find(:all, :include => :media_request_conversations)
  end

  def edit
    @media_request = MediaRequest.find(params[:id])
    @media_request_types = MediaRequestType.all
  end

  # def update
  # end

  # def destroy
  # end
end
