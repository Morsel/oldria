class Admin::HolidaysController < Admin::AdminController
  def index
    @holidays = Holiday.all(:order => 'date ASC, name ASC')
  end

  def show
    @holiday = Holiday.find(params[:id], :include => :admin_holiday_reminders)
    search_setup(@holiday)
  end

  def new
    @holiday = Holiday.new
    search_setup(@holiday)
  end

  def create
    @holiday = Holiday.new(params[:holiday])
    search_setup(@holiday)
    save_search
    if @holiday.save
      flash[:notice] = "Successfully created holiday."
      redirect_to admin_holidays_path
    else
      render :new
    end
  end

  def edit
    @holiday = Holiday.find(params[:id], :include => [:admin_holiday_reminders, :restaurants])
    search_setup(@holiday)
  end

  def update
    @holiday = Holiday.find(params[:id])
    search_setup(@holiday)
    save_search
    if @holiday.update_attributes(params[:holiday])
      flash[:notice] = "Successfully updated holiday."
      redirect_to admin_holidays_path
    else
      render :edit
    end
  end

  def destroy
    @holiday = Holiday.find(params[:id])
    @holiday.destroy
    flash[:notice] = "Successfully destroyed holiday."
    respond_to do |format|
      format.html { redirect_to admin_holidays_path }
      format.js   { head :ok }
    end
  end

end
