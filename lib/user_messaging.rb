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
      unread_admin_discussions.select { |d| d.comments_count > 0 && d.comments.last.user != self }
    end

    def unread_grouped_admin_discussions
      return @unread_grouped_admin_discussions if defined?(@unread_grouped_admin_discussions)
      @unread_grouped_admin_discussions = (current_admin_discussions - action_required_admin_discussions).group_by(&:discussionable)
      @unread_grouped_admin_discussions.reject! do |discussionable, admin_discussions|
        discussionable.read_by?(self) || (discussionable.scheduled_at < 2.weeks.ago)
      end
    end

    # Question of the day
    def unread_qotds
      admin_conversations.current.recent.without_replies.unread_by(self)
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
      [admin_conversations.current.action_required(self),
        action_required_admin_discussions,
        action_required_holidays
      ].flatten.sort { |a, b| b.comments.last.created_at <=> a.comments.last.created_at }
    end

    def messages_from_ria
      @messages_from_ria ||= [ unread_grouped_admin_discussions.keys,
        unread_hdrs,
        unread_qotds,
        unread_pr_tips,
        unread_announcements
      ].flatten.sort_by(&:scheduled_at).reverse
    end

    def all_messages
      @all_messages ||= [ current_admin_discussions,
        holiday_discussion_reminders,
        accepted_holiday_discussions,
        admin_conversations.current.all,
        Admin::Announcement.current.all,
        Admin::PrTip.current.all
      ].flatten.sort_by(&:scheduled_at).reverse
    end

    def ria_message_count
      action_required_messages.size + messages_from_ria.size
    end

end