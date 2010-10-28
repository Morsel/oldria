module UserMessaging

  # Received Media requests
  def viewable_media_request_discussions
    employments.map(&:viewable_media_request_discussions).flatten
  end

  def viewable_media_requests
    viewable_media_request_discussions.map(&:media_request)
  end

  # User Messages

  # Announcements
  def announcements
    Admin::Announcement.scoped(:order => "updated_at DESC").current
  end

  def unread_announcements
    Admin::Announcement.current.recent.find_unread_by( self )
  end

  # PR Tips
  def pr_tips
    Admin::PrTip.scoped(:order => "updated_at DESC").current
  end

  def unread_pr_tips
    Admin::PrTip.current.recent.find_unread_by( self )
  end

  # Admin discussions - includes content request, trend question
  def admin_discussions
    return @admin_discussions if defined?(@admin_discussions)
    @admin_discussions = employments.map(&:viewable_admin_discussions).flatten
  end

  def current_admin_discussions
    return @current_admin_discussions if defined?(@current_admin_discussions)
    @current_admin_discussions = employments.map(&:current_viewable_admin_discussions).flatten
  end

  def unread_admin_discussions
    current_admin_discussions.reject { |d| d.read_by?(self) }
  end

  def action_required_admin_discussions
    unread_admin_discussions.select { |d| d.comments_count > 0 && d.comments.last.user != self }.reject { |d| d.discussionable.is_a?(TrendQuestion) }
  end
  
  def grouped_admin_discussions
    return @grouped_admin_discussions if defined?(@grouped_admin_discussions)
    @grouped_admin_discussions = current_admin_discussions.group_by(&:discussionable)
  end

  def unread_grouped_admin_discussions
    return @unread_grouped_admin_discussions if defined?(@unread_grouped_admin_discussions)
    @unread_grouped_admin_discussions = (current_admin_discussions - action_required_admin_discussions).group_by(&:discussionable)
    @unread_grouped_admin_discussions.reject! do |discussionable, admin_discussions|
      discussionable.read_by?(self) || (discussionable.scheduled_at < 2.weeks.ago)
    end
  end

  def trend_questions_responded
    TrendQuestion.on_soapbox_with_response_from_user(self)
  end
  
  # Solo discussions
  
  def unread_solo_discussions
    solo_discussions.current.reject { |d| d.read_by?(self) }
  end

  # Question of the day
  def unread_qotds
    messages = admin_conversations.current.recent.unread_by(self)
  end

  def qotds_responded
    Admin::Qotd.on_soapbox_with_response_from_user(self)
  end

  # Restaurant staff discussions, site-wide user conversations
  def unread_discussions
    discussions.unread_by(self)
  end

  # Holiday mayhem

  def holiday_discussions
    HolidayDiscussion.for_restaurants(restaurants).select do |discussion|
      employment = discussion.restaurant.employments.find_by_employee_id(self.id)
      discussion.holiday.try(:viewable_by?, employment)
    end
  end

  def holiday_discussion_reminders
    holiday_discussions.reject(&:accepted?).map {|d| d.holiday_discussion_reminders.current.recent }
  end

  def unread_hdrs
    holiday_discussion_reminders.map { |r| r.find_unread_by(self) }.flatten
  end

  def action_required_holidays
    holiday_discussions.select { |d| d.action_required?(self) }
  end

  def accepted_holiday_discussions
    holiday_discussions.select(&:accepted?)
  end

  # Direct messages
  def unread_direct_messages
    direct_messages.unread_by(self)
  end

  def root_direct_messages # root is the first message in the thread
    (direct_messages.root + sent_direct_messages.root).sort_by(&:created_at).reverse
  end

  # Collections for display

  def action_required_messages
    [action_required_admin_discussions,
      action_required_holidays
    ].flatten.sort { |a, b| b.comments.last.created_at <=> a.comments.last.created_at }
  end

  def messages_from_ria
    @messages_from_ria ||= [ unread_grouped_admin_discussions.keys,
      unread_hdrs,
      unread_qotds,
      unread_pr_tips,
      unread_announcements,
      unread_solo_discussions
      ].flatten.sort_by(&:scheduled_at).reverse
  end

  def all_messages
    @all_messages ||= [ grouped_admin_discussions.keys,
      holiday_discussion_reminders,
      accepted_holiday_discussions,
      admin_conversations.current.all, # QOTDs
      Admin::Announcement.current.all,
      Admin::PrTip.current.all,
      solo_discussions.current
    ].flatten.sort_by(&:scheduled_at).reverse
  end

  def ria_message_count
    @ria_message_count ||= if action_required_messages
      action_required_messages.size + messages_from_ria.size
    else
      messages_from_ria.size
    end
  end

  def mark_replies_as_read
    action_required_messages.each { |m| m.read_by! self }
  end

end