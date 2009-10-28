class MediaRequestsController < ApplicationController
  def show
    @media_request = MediaRequest.find(params[:id])
  end
  
  def new
    @sender = current_user
    if params[:recipient_ids]
      @recipient_ids = params[:recipient_ids]
      @recipients = User.find(@recipient_ids)
    end
    @media_request = @sender.media_requests.build(:publication => @sender.publication)
    @media_request.attachments.build
    @media_request_types = MediaRequestType.all
  end
  
  def create
    @media_request = current_user.media_requests.build(params[:media_request])

    if params[:recipient_ids]
      for recipient in params[:recipient_ids]
        @media_request.media_request_conversations.build(:recipient_id => recipient)
      end      
    end

    if @media_request.save
      flash[:notice] = "Successfully created media request. It will be held for approval."
      redirect_to @media_request
    else
      render :new
    end
  end
  
  def edit
    @media_request_types = MediaRequestType.all
    @media_request = MediaRequest.find(params[:id])
  end
  
  def update
    @media_request = MediaRequest.find(params[:id])
    if @media_request.update_attributes(params[:media_request])
      flash[:notice] = "Successfully updated media request."
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
