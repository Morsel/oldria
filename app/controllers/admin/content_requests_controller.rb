class Admin::ContentRequestsController < Admin::AdminController
  def index
    @content_requests = ::ContentRequest.all(:include => :employment_search, 
                                                         :order => 'scheduled_at DESC, subject ASC')
  end

  def show
    @content_request = ::ContentRequest.find(params[:id])
    @content_request.scheduled_at = (@content_request.new_record? ? Time.now : @content_request.scheduled_at)
    search_setup(@content_request)
  end

  def new
    @content_request = ::ContentRequest.new
    @content_request.scheduled_at = (@content_request.new_record? ? Time.now : @content_request.scheduled_at)
    search_setup(@content_request)
  end

  def create
    @content_request = ::ContentRequest.new(params[:content_request])
    search_setup(@content_request)
    save_search
    if @content_request.save
      flash[:notice] = "Successfully created trend question."
      redirect_to([:admin, @content_request])
    else
      render :action => 'new'
    end
  end

  def edit
    @content_request = ::ContentRequest.find(params[:id], :include => :employment_search)
    @content_request.scheduled_at = (@content_request.new_record? ? Time.now : @content_request.scheduled_at)
    search_setup(@content_request)
  end

  def update
    @content_request = ::ContentRequest.find(params[:id])
    search_setup(@content_request)
    save_search
    if @content_request.update_attributes(params[:content_request])
      flash[:notice] = "Successfully updated trend question."
      redirect_to([:admin, @content_request])
    else
      render :action => 'edit'
    end
  end

  def destroy
    @content_request = ::ContentRequest.find(params[:id])
    @content_request.destroy
    flash[:notice] = "Successfully destroyed trend question."
    redirect_to admin_content_requests_path
  end
end
