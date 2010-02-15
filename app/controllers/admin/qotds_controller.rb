class Admin::QotdsController < Admin::AdminController
  def new
    # clean_search_params
    @qotd = Admin::Qotd.new
    @search = Employment.search(params[:search])

    if params[:search]
      @employments = @search.all(:select => 'DISTINCT employments.*', :include => [:restaurant])
      @search = Employment.search(nil) # reset the form
    end
  end

  def create
    @qotd = Admin::Qotd.new(params[:admin_qotd])
    @search = Employment.search(params[:search])
    if @qotd.save
      flash[:notice] = "Successfully created Question of the Day"
      redirect_to admin_messages_path
    else
      render :new
    end
  end

  def edit
    @qotd = Admin::Qotd.find(params[:id])
  end

  def update
    @qotd = Admin::Qotd.find(params[:id])
    if @qotd.update_attributes(params[:admin_qotd])
      flash[:notice] = "Successfully updated Question of the Day"
      redirect_to admin_messages_path
    else
      render :edit
    end
  end

  private

  def clean_search_params
    if params[:search] && (namelike = params[:search].delete(:restaurant_name_like))
      params[:search][:restaurant_name_like_all] = namelike.split unless namelike.blank?
    end
  end
end
