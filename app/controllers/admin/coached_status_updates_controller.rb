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
      flash[:notice] = "Successfully created Coached Status Update '#{@coached_status_update.message}'"
      if params[:save_and_new]
        redirect_to new_admin_coached_status_update_path
      else
        redirect_to admin_coached_status_updates_path
      end
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
      if params[:save_and_new]
        redirect_to new_admin_coached_status_update_path
      else
        redirect_to admin_coached_status_updates_path
      end
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
