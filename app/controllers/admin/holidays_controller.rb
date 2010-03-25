class Admin::HolidaysController < Admin::AdminController
  def index
    @holidays = Holiday.all(:order => 'date ASC, name ASC')
  end

  def show
    @holiday = Holiday.find(params[:id], :include => :admin_holiday_reminders)
  end

  def new
    @holiday = Holiday.new
    search_setup
  end

  def create
    @holiday = Holiday.new(params[:holiday])
    @search = Employment.search(params[:search])
    if @holiday.save
      flash[:notice] = "Successfully created holiday."
      redirect_to admin_holidays_path
    else
      render :new
    end
  end

  def edit
    @holiday = Holiday.find(params[:id], :include => :admin_holiday_reminders)
    search_setup
  end

  def update
    @holiday = Holiday.find(params[:id])
    @search = Employment.search(params[:search])
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
    redirect_to admin_holidays_path
  end

  private
  def search_setup
    @search = Employment.search(params[:search])

    if params[:search]
      @employments = @search.all(:select => 'DISTINCT employments.*', :include => [:restaurant])
      @search = Employment.search(nil) # reset the form
    end
  end
end
