##
# ::notify_recipients
#
# A generically-called public method that sets up and sends a UserMailer
# notification based on the users' preferences.
# This method must be implemented on all observed method types
#
class MessagingNotificationObserver < ActiveRecord::Observer
  observe DirectMessage, AdminDiscussion, Comment, Admin::Conversation, HolidayDiscussionReminder, Discussion, 
      Admin::Announcement, Admin::PrTip

  def after_create(message_record)
    if message_record.respond_to?(:notify_recipients)
      log_message_queueing(message_record)
      message_record.notify_recipients
    end
  end

  private

  def log_message_queueing(message_record)
    Rails.logger.info %Q{
    #{'*'*72}
     Attempting to send or queue message notification for [#{message_record.class} id:#{message_record.id}]
    #{'*'*72}
    }.gsub(/^ {4}/, '')
  end
end
