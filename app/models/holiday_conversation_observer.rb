class HolidayConversationObserver < ActiveRecord::Observer
  def after_save(holiday_conversation)
    if holiday_conversation.accepted
      return unless recipient = holiday_conversation.recipient
      holiday_conversation.holiday.remove_recipient_from_future_reminders(recipient)
    end
  end
end
