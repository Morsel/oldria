module Admin::AdminHelper
  def holiday_reply_count_link(holiday)
    link_to "#{holiday.reply_count} of #{holiday.holiday_conversations.count} replies",
    admin_holiday_path(holiday)
  end
end
