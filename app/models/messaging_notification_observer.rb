##
# ::notify_recipients
#
# A generically-called public method that sets up and sends a UserMailer
# notification based on the users' preferences.
# This method must be implemented on all observed method types
#
class MessagingNotificationObserver < ActiveRecord::Observer
  observe DirectMessage

  def after_create(message_record)
    message_record.notify_recipients if message_record.respond_to?(:notify_recipients)
  end
end
