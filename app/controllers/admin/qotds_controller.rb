class Admin::QotdsController < Admin::AdminController
  def new
    @qotd = Admin::Qotd.new
    @qotd.scheduled_at = Time.now
    search_setup
  end

  def create
    @qotd = Admin::Qotd.new(params[:admin_qotd])
    @search = Employment.search(normalized_search_params)
    
    @qotd.recipients = @search.all.map(&:employee).flatten.uniq

    if @qotd.save
      flash[:notice] = "Successfully created Question of the Day"
      redirect_to admin_messages_path
    else
      search_setup
      render :action => :new
    end
  end

  def edit
    @qotd = Admin::Qotd.find(params[:id])
    search_setup
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
end
