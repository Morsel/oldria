class Admin::HolidayRemindersController < Admin::AdminController
  def new
    # clean_search_params
    @holiday_reminder = Admin::HolidayReminder.new(:holiday_id => params[:holiday_id])
    @search = Employment.search(params[:search])

    if params[:search]
      @employments = @search.all(:select => 'DISTINCT employments.*', :include => [:restaurant])
      @search = Employment.search(nil) # reset the form
    end
  end

  def create
    @holiday_reminder = Admin::HolidayReminder.new(params[:admin_holiday_reminder])
    @search = Employment.search(params[:search])
    if @holiday_reminder.save
      flash[:notice] = "Successfully created Holiday Reminder"
      redirect_to admin_messages_path
    else
      render :new
    end
  end

  def edit
    @holiday_reminder = Admin::HolidayReminder.find(params[:id])
  end

  def update
    @holiday_reminder = Admin::HolidayReminder.find(params[:id])
    if @holiday_reminder.update_attributes(params[:admin_holiday_reminder])
      flash[:notice] = "Successfully updated Holiday Reminder"
      redirect_to admin_messages_path
    else
      render :edit
    end
  end

end
