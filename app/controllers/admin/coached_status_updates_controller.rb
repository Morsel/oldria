class Admin::CoachedStatusUpdatesController < Admin::AdminController
  def index
    @coached_status_updates = CoachedStatusUpdate.all(:include => :date_range)
  end
  
  def show
    @coached_status_update = CoachedStatusUpdate.find(params[:id])
  end
  
  def new
    @coached_status_update = CoachedStatusUpdate.new
  end
  
  def create
    @coached_status_update = CoachedStatusUpdate.new(params[:coached_status_update])
    if @coached_status_update.save
      flash[:notice] = "Successfully created Coached Status Update."
      redirect_to [:admin, @coached_status_update]
    else
      render :new
    end
  end
  
  def edit
    @coached_status_update = CoachedStatusUpdate.find(params[:id])
  end
  
  def update
    @coached_status_update = CoachedStatusUpdate.find(params[:id])
    if @coached_status_update.update_attributes(params[:coached_status_update])
      flash[:notice] = "Successfully updated coached status update."
      redirect_to [:admin, @coached_status_update]
    else
      render :edit
    end
  end
  
  def destroy
    @coached_status_update = CoachedStatusUpdate.find(params[:id])
    @coached_status_update.destroy
    flash[:notice] = "Successfully destroyed coached status update."
    redirect_to admin_coached_status_updates_path
  end
end
