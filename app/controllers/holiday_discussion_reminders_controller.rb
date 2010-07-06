class HolidayDiscussionRemindersController < ApplicationController
  before_filter :require_user

  def show
    hdr = HolidayDiscussionReminder.find(params[:id])
    redirect_to hdr.holiday_discussion
  end

  def read
    reminder = HolidayDiscussionReminder.find(params[:id])
    reminder.read_by!(current_user)
    render :nothing => true
  end

end
