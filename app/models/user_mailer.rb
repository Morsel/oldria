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

  def media_request_notification(request, request_conversation)
    from       'notifications@restaurantintelligenceagency.com'
    recipients request_conversation.recipient.employee.email
    sent_on    Time.now
    subject    "SpoonFeed: #{request.publication_string} has a question for you"
    body       :request_conversation => request_conversation, :request => request
  end

  def employee_invitation(user, invitation_sender = nil)
    from          'accounts@restaurantintelligenceagency.com'
    recipients    user.email
    sent_on       Time.now
    subject       "SpoonFeed: You've been added"
    body          :user => user, :invitation_sender => invitation_sender
  end

  def discussion_notification(discussion, user)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  user.email
    sent_on     Time.now
    subject     "SpoonFeed: #{discussion.poster.try :name} has invited you to a discussion"
    body        :discussion => discussion, :user => user
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
