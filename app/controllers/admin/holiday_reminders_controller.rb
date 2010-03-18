class Admin::HolidayRemindersController < Admin::AdminController
  def new
    @holiday_reminder = Admin::HolidayReminder.new(:holiday_id => params[:holiday_id])
    @holiday_reminder.recipient_ids = @holiday_reminder.holiday.recipient_ids if @holiday_reminder.holiday
  end

  def create
    @holiday_reminder = Admin::HolidayReminder.new(params[:admin_holiday_reminder])
    if @holiday_reminder.save
      flash[:notice] = "Successfully created Holiday Reminder"
      redirect_to (@holiday_reminder.holiday ? [:admin, @holiday_reminder.holiday] : admin_messages_path)
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
      redirect_to (@holiday_reminder.holiday ? [:admin, @holiday_reminder.holiday] : admin_messages_path)
    else
      render :edit
    end
  end

end
