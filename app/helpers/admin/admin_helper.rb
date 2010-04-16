module Admin::AdminHelper
  def holiday_reply_count_link(holiday)
    link_to "#{holiday.reply_count} of #{holiday.holiday_discussions.count} replies",
    admin_holiday_path(holiday)
  end

  def reply_count_link(discussionable)
    link_to "#{discussionable.admin_discussions.with_replies.size} of #{discussionable.admin_discussions.size} replies", [:admin, discussionable]
  end
end
