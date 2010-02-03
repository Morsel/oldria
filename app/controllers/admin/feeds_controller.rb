class Admin::FeedsController < Admin::AdminController
  def index
    @feed_categories = FeedCategory.all(:include => :feeds)
    @uncategorized_feeds = Feed.uncategorized.all
  end

  def show
    @feed = Feed.find(params[:id])
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(params[:feed])
    if @feed.save
      flash[:notice] = "Successfully created feed."
      redirect_to admin_feeds_path
    else
      render :new
    end
  end

  def edit
    @feed = Feed.find(params[:id])
  end

  def update
    @feed = Feed.find(params[:id])
    if @feed.update_attributes(params[:feed])
      flash[:notice] = "Successfully updated feed."
      redirect_to admin_feeds_path
    else
      render :edit
    end
  end

  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy
    flash[:notice] = "Successfully destroyed feed."
    respond_to do |format|
      format.html { redirect_to admin_feeds_path }
      format.js { render :nothing => true }
    end
  end

  ##
  # Custom sort method for AJAX sortability
  #
  #   POST /feeds/sort
  def sort
    params[:feeds].each_with_index do |id, index|
      Feed.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end
end
