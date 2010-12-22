class Mediafeed::MediaRequestsController < Mediafeed::MediafeedController
  before_filter :require_user, :only => [:index, :show]
  before_filter :require_media_user, :except => [:index, :show]
  before_filter :get_reply_count, :only => [:index, :show]

  def index
    if current_user.media?
      @media_requests = params[:view_all] ? 
          current_user.media_requests.all(:include => [:subject_matter, :restaurants]) :
          @media_requests_with_replies #set in :get_reply_count
    else
      # These are always scoped by restaurant!
      @restaurant = Restaurant.find(params[:restaurant_id])
      @media_requests = @restaurant.media_requests.all(:include => [:sender, :conversations_with_comments])
    end
  end

  def show
    @media_request = MediaRequest.find(params[:id])
    @comments = []
    @media_request.discussions_with_comments.each do |discussion|
      @comments << discussion.comments.not_user(current_user).all(:include => [:user, :attachments], :order => 'created_at DESC').reject(&:new_record?)
    end
    build_comment
  end

  def new
    @media_request = current_user.media_requests.build(params[:media_request])
    @media_request.attachments.build
    search_setup(@media_request)
  end

  def create
    @media_request = current_user.media_requests.build(params[:media_request])
    search_setup(@media_request)
    if @media_request.save
      flash[:notice] = "Thank you! Your query is fast on its way to the recipients you selected. You’ll be alerted that answers have arrived (shortly, we hope!) via an email sent to your email inbox. For your convenience, then, everything will be privately and securely stored here for you. Thanks again, and please do give us feedback!"
      redirect_to [:mediafeed, @media_request]
    else
      flash.now[:error] = "Oops! No one would get the media request based on your criteria. Are you sure you checked the boxes? Please retry your search, broadening your criteria if necessary."
      render :new
    end
  end

  def edit
    @subject_matters = SubjectMatter.all
    @media_request = MediaRequest.find(params[:id])
    @media_request.publication = @media_request.sender.try(:publication)
    @restaurants = @media_request.restaurants
  end

  def update
    @media_request = MediaRequest.find(params[:id])
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
  
  protected
  
  def get_reply_count
    if mediafeed?
      @media_requests_with_replies = current_user.media_requests.all(:include => [:subject_matter, :restaurants]).select { |m| m.discussions_with_comments.present? }
      @media_requests_with_replies_count = @media_requests_with_replies.size
    end
  end
end
