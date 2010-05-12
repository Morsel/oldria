##
# ::notify_recipients
#
# A generically-called public method that sets up and sends a UserMailer
# notification based on the users' preferences.
# This method must be implemented on all observed method types
#
class MessagingNotificationObserver < ActiveRecord::Observer
  observe DirectMessage, Admin::Conversation

  def after_create(message_record)
    if message_record.respond_to?(:notify_recipients)
      Rails.logger.info "*"*55 +
        "\nAttempting to send message <\##{message_record.class} id:#{message_record.id}>\n" + "*"*55
      message_record.notify_recipients
    end
  end
end
