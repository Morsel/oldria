class Mediafeed::MediaRequestsController < Mediafeed::MediafeedController
  before_filter :require_user, :only => [:index, :show]
  before_filter :require_media_user, :except => [:index, :show]

  def index
    # These are always scoped by restaurant!
    @restaurant = Restaurant.find(params[:restaurant_id])
    @media_requests = @restaurant.media_requests.all(:include => [:sender, :conversations_with_comments])
  end

  def show
    @media_request = MediaRequest.find(params[:id])
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
      redirect_to @media_request
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
end
