class Admin::DateRangesController < Admin::AdminController
  def index
    @date_ranges = DateRange.all
  end
  
  def show
    @date_range = DateRange.find(params[:id])
  end
  
  def new
    @date_range = DateRange.new
  end
  
  def create
    @date_range = DateRange.new(params[:date_range])
    if @date_range.save
      flash[:notice] = "Successfully created date range."
      redirect_to admin_date_ranges_path
    else
      render :new
    end
  end
  
  def edit
    @date_range = DateRange.find(params[:id])
  end
  
  def update
    @date_range = DateRange.find(params[:id])
    if @date_range.update_attributes(params[:date_range])
      flash[:notice] = "Successfully updated date range."
      redirect_to admin_date_ranges_path
    else
      render :edit
    end
  end
  
  def destroy
    @date_range = DateRange.find(params[:id])
    if @date_range.coached_status_updates.blank?
      @date_range.destroy
      flash[:notice] = "Successfully destroyed date range."
    else
      flash[:error] = "You can't delete that, because there are status updates that are using it."
    end
    redirect_to admin_date_ranges_path
  end
end
