class Admin::ContentRequestsController < Admin::AdminController
  def index
    @content_requests = ::ContentRequest.all
  end

  def show
    @content_request = ::ContentRequest.find(params[:id])
    search_setup
  end

  def new
    @content_request = ::ContentRequest.new
    search_setup
  end

  def create
    @content_request = ::ContentRequest.new(params[:content_request])
    search_setup
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
    search_setup
  end

  def update
    @content_request = ::ContentRequest.find(params[:id])
    search_setup
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

  private
  def search_setup
    @employment_search = if @content_request.employment_search
        @content_request.employment_search
      else
        @content_request.build_employment_search(:conditions => {})
      end

    @search = @employment_search.employments #searchlogic
    @restaurants_and_employments = @search.all(:include => [:restaurant, :employee]).group_by(&:restaurant)
  end

  def save_search
    if params[:search]
      @employment_search.conditions = normalized_search_params
      @employment_search.save
    end
  end

  def normalized_search_params
    normalized = params[:search].reject{|k,v| v.blank? }
    normalized.blank? ? {:id => ""} : normalized
  end
end
