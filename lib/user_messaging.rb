module UserMessaging

  # Received Media requests
  def viewable_media_request_discussions
    @viewable_media_request_discussions ||= all_employments.map(&:viewable_media_request_discussions).flatten
  end

  def viewable_unread_media_request_discussions
    @viewable_unread_media_request_discussions ||= all_employments.map(&:viewable_unread_media_request_discussions).flatten
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
    Admin::Announcement.current.recent.find_unread_by(self)
  end

  # PR Tips
  def pr_tips
    Admin::PrTip.scoped(:order => "updated_at DESC").current
  end

  def unread_pr_tips
    Admin::PrTip.current.recent.find_unread_by(self)
  end

  # Admin discussions
  def admin_discussions
    return @admin_discussions if defined?(@admin_discussions)
    @admin_discussions = employments.map(&:viewable_admin_discussions).flatten
  end

  def current_admin_discussions
    @current_admin_discussions ||= employments.map(&:current_viewable_admin_discussions).flatten
  end

  def unread_admin_discussions
    current_admin_discussions.reject { |d| d.read_by?(self) }
  end

  def grouped_admin_discussions
    return @grouped_admin_discussions if defined?(@grouped_admin_discussions)
    @grouped_admin_discussions = current_admin_discussions.group_by(&:discussionable)
  end

  def unread_grouped_admin_discussions
    return @unread_grouped_admin_discussions if defined?(@unread_grouped_admin_discussions)
    @unread_grouped_admin_discussions = (current_admin_discussions).group_by(&:discussionable)
    @unread_grouped_admin_discussions.reject! do |discussionable, admin_discussions|
      discussionable.read_by?(self) || (discussionable.scheduled_at < 2.weeks.ago)
    end
  end
  
  # Trend questions
  def trend_questions
    employments.map(&:current_viewable_trend_discussions).flatten
  end
  
  def unread_trend_questions
    trend_questions.reject { |t| t.read_by?(self) || (t.scheduled_at < 2.weeks.ago) }
  end
  
  def grouped_trend_questions
    @grouped_trend_questions ||= trend_questions.group_by(&:discussionable)
  end
  
  def unread_grouped_trend_questions
    @unread_grouped_trend_questions ||= unread_trend_questions.group_by(&:discussionable)
  end

  def trend_questions_responded
    TrendQuestion.on_soapbox_with_response_from_user(self)
  end
  
  # Solo discussions
  def unread_solo_discussions
    solo_discussions.current.find_unread_by(self)
  end
  
  # Content requests
  def content_requests
    employments.map(&:current_viewable_request_discussions).flatten
  end

  def grouped_content_requests
    @grouped_content_requests ||= content_requests.group_by(&:discussionable)
  end
  
  def unread_grouped_content_requests
    @unread_grouped_content_requests ||= grouped_content_requests
    @unread_grouped_content_requests.reject! do |discussionable, request|
      discussionable.read_by?(self) || (discussionable.scheduled_at < 2.weeks.ago)
    end
  end

  # Question of the day
  def unread_qotds
    admin_conversations.current.recent.find_unread_by(self)
  end

  def qotds_responded
    Admin::Qotd.on_soapbox_with_response_from_user(self)
  end

  # Restaurant staff discussions, site-wide user conversations
  def unread_discussions
    discussions.find_unread_by(self)
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

  def accepted_holiday_discussions
    holiday_discussions.select(&:accepted?)
  end

  # Direct messages
  def unread_direct_messages
    direct_messages.find_unread_by(self)
  end

  def root_direct_messages # root is the first message in the thread
    (direct_messages.root + sent_direct_messages.root).sort_by(&:created_at).reverse
  end

  # Collections for display

  def messages_from_ria
    @messages_from_ria ||= [unread_pr_tips,
                            unread_announcements].flatten.sort_by(&:scheduled_at).reverse
  end

  def all_messages_from_ria
    @all_messages ||= [Admin::Announcement.current.all,
                       Admin::PrTip.current.all].flatten.sort_by(&:scheduled_at).reverse
  end

  def ria_message_count
    @ria_message_count ||= unread_pr_tips.count + unread_announcements.count
  end
  
  def message_inbox_count
    @message_inbox_count ||= (ria_message_count + 
                              unread_discussions.count +
                              discussions.with_comments_unread_by(self).count +
                              unread_direct_messages.count +
                              viewable_unread_media_request_discussions.size)
  end
  
  def front_burner_unread_count
    @front_burner_unread_count ||= unread_qotds.count + unread_grouped_trend_questions.keys.size + unread_solo_discussions.count
  end
  
  # def mediafeed_discussions_with_replies_count
  #   FIXME MediaRequestsController tests are breaking
  #   if media_requests.present?
  #     media_requests.map(&:discussions_with_comments).flatten.size
  #   else
  #     0
  #   end
  # end

end