class UserMailer < ActionMailer::Base
  default_url_options[:host] = DEFAULT_HOST

  def signup(user = nil, sent_at = Time.now)
    if user
      from       'accounts@restaurantintelligenceagency.com'
      recipients user.email
      sent_on    sent_at
      subject    'Welcome to SpoonFeed! Please confirm your account'
      body       :user => user
    end
  end

  def password_reset_instructions(user)
    from          'accounts@restaurantintelligenceagency.com'
    recipients    user.email
    sent_on       Time.now
    subject       "SpoonFeed: Password Reset Instructions"
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def media_request_notification(request_discussion, user)
    from       'notifications@restaurantintelligenceagency.com'
    recipients user.email
    sent_on    request_discussion.created_at
    subject    "SpoonFeed: #{request_discussion.publication_string} has a question for #{request_discussion.restaurant.name}"
    body       :request => request_discussion.media_request, :discussion => request_discussion
  end

  def discussion_notification(discussion, user)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  user.email
    sent_on     Time.now
    subject     "SpoonFeed: #{discussion.poster.try :name} has invited you to a discussion"
    body        :discussion => discussion, :user => user
  end
  
  # sent to users who request an invite for themselves
  def invitation_welcome(invite)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  invite.email
    sent_on     Time.now
    subject     "Thanks for your interest in Spoonfeed!"
    body        :invitation => invite
  end
  
  # sent to admins to let them know a new invite has been requested
  def admin_invitation_notice(invite)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  'info@restaurantintelligenceagency.com'
    sent_on     Time.now
    subject     'A new invitation has been requested'
    body        :invitation => invite
  end
  
  # sent to all users after their invite is accepted by an admin
  def employee_invitation(user, invitation_sender = nil)
    from          'accounts@restaurantintelligenceagency.com'
    recipients    user.email
    sent_on       Time.now
    subject       "SpoonFeed: You're invited"
    body          :user => user, :invitation_sender => invitation_sender
  end
  
  # sent to the restaurant manager after a user joins and requests to be added to the restaurant as an employee
  def employee_request(restaurant, user)
    from          'accounts@restaurantintelligenceagency.com'    
    recipients    restaurant.manager.email
    sent_on       Time.now
    subject       "SpoonFeed: a new employee has joined"
    body          :recipient => restaurant.manager, :user => user, :restaurant => restaurant
  end

  ##
  # Generic message: could be one of DirectMessage, etc.
  def message_notification(message, recipient, sender = nil)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  recipient.email
    sent_on     Time.now
    subject     "SpoonFeed: #{message.email_title} notification"
    body        :message => message, :recipient => recipient, :sender => sender
  end

  ##
  # Comment on a generic message: could be one of DirectMessage, etc.
  def message_comment_notification(message, recipient, commenter = nil)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  recipient.email
    sent_on     Time.now
    subject     "SpoonFeed: #{message.email_title} comment notification"
    body        :message => message, :recipient => recipient, :commenter => commenter
  end

end
