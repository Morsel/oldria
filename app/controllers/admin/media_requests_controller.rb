class Admin::MediaRequestsController < Admin::AdminController

  # GET /admin/media_requests
  def index
    @media_requests = MediaRequest.find(:all, :include => :media_request_discussions, :order => "id DESC")
    @approved_media_requests = @media_requests.select(&:approved?)
    @pending_media_requests = @media_requests.select(&:pending?)
  end

  # GET /admin/media_requests/1
  def show
    @media_request = MediaRequest.find(params[:id], :include => :restaurants)
  end

  # GET /admin/media_requests/1/edit
  def edit
    @media_request = MediaRequest.find(params[:id])
    @subject_matters = SubjectMatter.all
  end

  # PUT /admin/media_requests/1
  def update
    @subject_matters = SubjectMatter.all
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

  def media_requests_list
    @media_request = MediaRequest.find(params[:id])
    @media_requests_with_replies = @media_request.discussions_with_comments
    @media_requests_without_replies = @media_request.discussions_without_comments
  end  

  def send_media_mail
    if !params[:solo_media_discussion].nil?
       smdc = SoloMediaDiscussion.find(params[:id])
       UserMailer.deliver_media_mail(smdc.employee,smdc.media_request,smdc)
    else  
      mrd = MediaRequestDiscussion.find(params[:media_requests_discussion])
      UserMailer.deliver_media_mail(mrd.restaurant.employees,mrd.media_request,mrd)
    end    
    flash[:success] = "Successfully notified to users."
    redirect_to media_requests_list_admin_media_request_path
  end 


end
