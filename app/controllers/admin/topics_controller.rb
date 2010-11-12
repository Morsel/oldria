class Admin::TopicsController < Admin::AdminController
  
  def index
    @topics = Topic.all(
                :conditions => {:responder_type => h(params[:responder_type])},
                :order => "position ASC, title ASC")
  end

  def new
    @topic = Topic.new
    render :action => "edit"
  end

  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      flash[:notice] = "Created new topic named #{@topic.title}"
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def show
    redirect_to :action => "edit", :id => params[:id]
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      flash[:notice] = "Updated topic"
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    if @topic.chapters.count > 0
      flash[:error] = "Unable to delete topics currently assigned to chapters"
    else
      flash[:notice] = "Deleted topic #{@topic.title}"
      @topic.destroy
    end
    redirect_to :action => "index"
  end

end
