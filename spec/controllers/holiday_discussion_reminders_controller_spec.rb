# require_relative '../spec_helper'
# 
# describe HolidayDiscussionRemindersController do
# 
#   it "should mark a reminder as read" do
#     fake_normal_user
#     reminder = Factory(:holiday_discussion_reminder)
#     HolidayDiscussionReminder.expects(:find).with(reminder.id.to_s).returns(reminder)
#     reminder.expects(:read_by!).with(@controller.current_user)
#     xhr :put, :read, :id => reminder.id
#   end
# 
# end
