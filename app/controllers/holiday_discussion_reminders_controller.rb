class HolidayDiscussionRemindersController < ApplicationController
  
  def read
    reminder = HolidayDiscussionReminder.find(params[:id])
    reminder.read_by!(current_user)
    render :nothing => true
  end
  
end
