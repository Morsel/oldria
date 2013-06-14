class UserMailer < ActionMailer::Base
  helper :mailer
  default_url_options[:host] = DEFAULT_HOST

  def signup(user = nil, sent_at = Time.now)
    if user
      from       'accounts@restaurantintelligenceagency.com'
      recipients user.email
      sent_on    sent_at
      subject    'Welcome to Spoonfeed! Please confirm your account'
      body       :user => user
    end
  end

  def password_reset_instructions(user)
    from          'accounts@restaurantintelligenceagency.com'
    recipients    user.email
    sent_on       Time.now
    subject       "Spoonfeed: Password Reset Instructions"
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def media_request_notification(request_discussion, user)
    from       'notifications@restaurantintelligenceagency.com'
    recipients user.email_for_content
    sent_on    request_discussion.created_at
    subject    "Spoonfeed: #{request_discussion.publication_string} has a question for #{request_discussion.recipient_name}"
    body       :request => request_discussion.media_request, :discussion => request_discussion
  end

  def discussion_notification(discussion, user)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  user.email
    sent_on     Time.now
    subject     "Spoonfeed: #{discussion.poster.try :name} has invited you to a discussion"
    body        :discussion => discussion, :user => user
  end
  
  # sent to people recommended by another user
  def signup_recommendation(email, referring_user)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  email
    sent_on     Time.now
    subject     "Spoonfeed referral from #{referring_user.name}"
    body        :referring_user => referring_user
  end
  
  # sent to users who request an invite for themselves
  def invitation_welcome(invite)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  invite.email
    sent_on     Time.now
    subject     "Spoonfeed Invitation Request Received"
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
  def new_user_invitation(user, invitation_sender = nil)
    from          'accounts@restaurantintelligenceagency.com'
    recipients    user.email
    sent_on       Time.now
    subject       "Your invitation to Spoonfeed has arrived!"
    body          :user => user, :invitation_sender => invitation_sender
  end
  
  # sent to the restaurant manager after a user joins and requests to be added to the restaurant as an employee
  def employee_request(restaurant, user)
    from          'accounts@restaurantintelligenceagency.com'    
    recipients    restaurant.manager.email
    sent_on       Time.now
    subject       "Spoonfeed: a new employee has joined"
    body          :recipient => restaurant.manager, :user => user, :restaurant => restaurant
  end

  ##
  # Generic message: could be one of DirectMessage, etc.
  def message_notification(message, recipient, sender = nil)
    
    from        'notifications@restaurantintelligenceagency.com'
    recipients  [recipient.email]
    sent_on     Time.now
    subject     "Spoonfeed: #{message.email_title} notification"
    body        :message => message, :recipient => recipient, :sender => sender
  end

  ##
  # Generic message which can be 'answered': could be one of QOTD, etc.
  def answerable_message_notification(message, recipient)

    from        'notifications@restaurantintelligenceagency.com'
    reply_to    recipient.cloudmail_id(message)+"@#{CLOUDMAIL_DOMAIN}"
    recipients  recipient.email_for_content
    sent_on     Time.now
    subject     "Spoonfeed: #{message.email_title} notification"
    body        :message => message, :recipient => recipient
  end

  # Error email for answerable messages
  def answerable_message_error(message, recipient, error_text, allow_reply = true)
    from        'notifications@restaurantintelligenceagency.com'
    reply_to    recipient.cloudmail_id(message)+"@#{CLOUDMAIL_DOMAIN}"
    recipients  recipient.email_for_content
    sent_on     Time.now
    subject     "Spoonfeed: #{message.email_title} response error"
    body        :message => message, :recipient => recipient, :error_text => error_text, :allow_reply => allow_reply
  end

  ##
  # Comment on a generic message: could be one of DirectMessage, etc.
  def message_comment_notification(type,message, recipient, commenter = nil)
    from        'notifications@restaurantintelligenceagency.com'
    if type == "MediaRequestDiscussion"
      if commenter.media_notification?
      recipients  [recipient.email_for_content,commenter.email] 
      else
      recipients  [recipient.email_for_content]
      end
    end  

    if type == "AdminDiscussion"
      if commenter.whats_new_notification?
      recipients  [recipient.email_for_content,commenter.email] 
      else
      recipients  [recipient.email_for_content]
      end
    end

    sent_on     Time.now
    subject     "Spoonfeed: #{message.email_title} comment notification"
    body        :message => message, :recipient => recipient, :commenter => commenter
  end

  def newsletter_subscription_confirmation(subscriber)
    from        'accounts@restaurantintelligenceagency.com'
    recipients  subscriber.email
    sent_on     Time.now
    subject     'Confirm your Soapbox email newsletter subscription'
    body        :subscriber => subscriber
  end

  def admin_notification(message, recipient,email)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  "admin@restaurantintelligenceagency.com"   
    #will use it after client will test
    #recipients   [message.sender.email , "admin@restaurantintelligenceagency.com",email]
    sent_on     Time.now
    subject     "An item is posted to Newsfeed notification "
    body        :message => message, :recipient => recipient
    
  end
    
  def cloudmailin_error(email)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  email
    sent_on     Time.now
    subject     'Spoonfeed: Email message error'
  end


  def newsletter_preview_reminder(restaurant)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  restaurant.manager.email
    sent_on     Time.now
    subject     'Spoonfeed: Review your newsletter now'
    body        :restaurant => restaurant
  end


  def add_keyword_request(restaurant,keyword)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  "admin@restaurantintelligenceagency.com"
    sent_on     Time.now
    subject     "Keyword Request from RESTAURANT NAME: #{restaurant} REQUESTED ITEM: #{keyword}"
  end
  
  def send_mail_visitor(restaurant_visitors)
    from        'hal@restaurantintelligenceagency.com'
    recipients  ['eric@restaurantintelligenceagency.com',"ellen@restaurantintelligenceagency.com","nishant.n@cisinlabs.com"]#visitor_obj.restaurant.manager.try(:email)
    sent_on     Time.now
    subject     "You have visitors!"
    body       restaurant_visitors
  end
  

  def send_chef_user(restaurant_visitors)
    from        'hal@restaurantintelligenceagency.com'
    recipients  ['eric@restaurantintelligenceagency.com',"ellen@restaurantintelligenceagency.com","nishant.n@cisinlabs.com"]#visitor_obj.restaurant.manager.try(:email)
    sent_on     Time.now
    subject     "Connect with media"
    body       restaurant_visitors
  end

  def send_payment_error(name,message)
    @message = message
    from        'notifications@restaurantintelligenceagency.com'
    recipients  "eric@restaurantintelligenceagency.com"
    sent_on     Time.now
    subject     "Spoonfeed::Payment faild! :: #{name}"
  end  

  def send_braintree_payment_error(name,link=nil)
    @name = name
    @link = link
    from        'notifications@restaurantintelligenceagency.com'
    recipients  "eric@restaurantintelligenceagency.com"
    sent_on     Time.now
    subject     "Spoonfeed: We are sorry!"
  end  


  def request_info_mail(title,detail,user,restaurant,comment,subject,sender)
    from        sender.email
    recipients  user.email   
    cc restaurant.manager.try(:email) unless user.email == restaurant.manager.try(:email) 
    sent_on     Time.now
    subject     "#{subject} Media Request via RIA" 
    body        :detail => detail,:title => title,:user =>user,:comment=>comment
  end  


  def send_james_bear_region_request(jbrr,requested)
    @jbrr = jbrr
    @requested = requested
    from        requested
    recipients  "admin@restaurantintelligenceagency.com"
    sent_on     Time.now
    subject     "Spoonfeed: James Bear Region Request!"
  end  


  def export_press_kit(email,user,restaurant)
    from        user.email
    recipients  email   
    sent_on     Time.now
    subject     "#{user.username} sent you a link to their restaurant profile." 
    body        :user => user,:restaurant=> restaurant
  end  



  def send_employee_claim_notification_mail(user,employee,restaurant)
    from        'notifications@restaurantintelligenceagency.com'
    recipients  user.email   
    cc restaurant.manager.try(:email) unless user.email == restaurant.manager.try(:email) 
    sent_on     Time.now
    subject     "#{subject} Employee Claim Notification Mail via RIA" 
    body        :employee=>employee,:user=>user,:restaurant=>restaurant
  end



  def export_press_kit_for_media(email,user,restaurant)

    from        user.email
    recipients  email   
    sent_on     Time.now
    subject     "#{user.username} sent you a link to their restaurant profile." 
    body        :user => user,:restaurant=> restaurant
  end  


end
