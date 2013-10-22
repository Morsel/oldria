class Mediafeed::MediaRequestsController < Mediafeed::MediafeedController
  
  skip_before_filter :require_user
  before_filter :require_user
  before_filter :find_and_authorize, :only => [:show, :edit, :update, :destroy, :discussion]
  before_filter :get_reply_count, :only => [:index, :show, :discussion]

  def index
      @media_requests = params[:view_all] ? 
          current_user.media_requests.all(:include => [:subject_matter, :restaurants]) :
          @media_requests_with_replies #set in :get_reply_count
  end

  def new
    @media_request = current_user.media_requests.build(params[:media_request])
    @media_request.attachments.build
    search_setup(@media_request, User.mediafeed_only_condition)
    render :layout => "application"
  end

  def create
    @media_request = current_user.media_requests.build(params[:media_request])
    search_setup(@media_request, User.mediafeed_only_condition)

    # Step 1: Media requests must include a subject matter in the criteria
    unless params[:search][:subject_matters_id_equals_any].compact.any?
      @media_request.errors.add_to_base("Please begin by selecting a subject matter")
      flash.now[:error] = @media_request.errors.full_messages.to_sentence
      render :new and return
    end

    if @media_request.save
      @media_request.notify_media_request!
      flash[:notice] = "Thank you! Your query is fast on its way to the recipients you selected. You'll be alerted that answers have arrived (shortly, we hope!) via an email sent to your email inbox. For your convenience, then, everything will be privately and securely stored here for you. Thanks again, and please do give us feedback!"
      redirect_to [:mediafeed, @media_request]
    else
      if @employment_search.employments.blank?
        flash.now[:error] = "Oops! No one would get the media request based on your criteria. Are you sure you checked the boxes? Please retry your search, broadening your criteria if necessary."
      else
        flash.now[:error] = @media_request.errors.full_messages.to_sentence
      end
      render :new
    end
  end

  def show
  end

  def edit
    @subject_matters = SubjectMatter.all
    @media_request.publication = @media_request.sender.try(:publication)
    @restaurants = @media_request.restaurants
  end

  def update
    if @media_request.update_attributes(params[:media_request])
      flash[:notice] = "Thanks! Your media request will be sent shortly!"
      redirect_to @media_request
    else
      render :edit
    end
  end

  def destroy
    @media_request.destroy
    flash[:notice] = "Successfully destroyed media request."
    redirect_to media_requests_url
  end
  
  def discussion
    collection = params[:discussion_type]
    @media_request_discussion = @media_request.send(collection.to_sym).find(params[:discussion_id])
    build_comment
  end
  
  protected

  def get_reply_count
    if mediafeed?
      @media_requests_with_replies = current_user.media_requests.all(:include => [:subject_matter, :restaurants]).select { |m| m.discussions_with_comments.present? }
      @media_requests_with_replies_count = @media_requests_with_replies.size
    end
  end

  def build_comment
    @comment = @media_request_discussion.comments.build
    @comment.attachments.build
    @comment.user = current_user
    @comment_resource = [@media_request_discussion, @comment]
  end

  def find_and_authorize
    @media_request = MediaRequest.find(params[:id])
    unauthorized! if cannot? :read, @media_request
  end

end
