class Admin::MediaRequestsController < Admin::AdminController
  
  def index
    @media_requests = MediaRequest.find(:all, :include => :media_request_conversations)
  end

  # def show
  # end

  # def edit
  # end


  # def update
  # end

  # def destroy
  # end
end
