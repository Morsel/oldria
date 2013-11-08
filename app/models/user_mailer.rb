class UserMailer < ActionMailer::Base
  helper :mailer
  default_url_options[:host] = DEFAULT_HOST

  def signup(user = nil, sent_at = Time.now)
    if user
      @user = user
      mail(
      :from => 'accounts@restaurantintelligenceagency.com',
      :to   =>  user.email,
      :sent_on => sent_at,
      :subject => 'Welcome to Spoonfeed! Please confirm your account'
      )
    end
  end

  def signup_for_soapbox(user = nil, sent_at = Time.now)
    if user
      @user = user
      mail(
      :from => 'accounts@restaurantintelligenceagency.com',
      :to   =>  user.email,
      :sent_on => sent_at,
      :subject => 'Welcome to Soapbox! Please confirm your account'
      )
    end
  end

  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(
      :from => 'accounts@restaurantintelligenceagency.com',
      :to   =>  user.email,
      :sent_on => Time.now,
      :subject => "Spoonfeed: Password Reset Instructions"
      )
  end

  def password_reset_instructions_for_soapbox(user)
    @edit_soapbox_soapbox_password_reset_url =  edit_soapbox_soapbox_password_reset_url(user.perishable_token)
    mail(
      :from => 'accounts@restaurantintelligenceagency.com',
      :to   =>  user.email,
      :sent_on => Time.now,
      :subject => "Soapbox: Password Reset Instructions"
      )
  end

  def media_request_notification(request_discussion, user)
    @request = request_discussion.media_request
    @discussion = request_discussion
    mail(
      :from => 'notifications@restaurantintelligenceagency.com',
      :to   =>  user.email_for_content,
      :sent_on => request_discussion.created_at,
      :subject => "Spoonfeed: #{request_discussion.publication_string} has a question for #{request_discussion.recipient_name}"
      )
  end

  def discussion_notification(discussion, user)
    @discussion = discussion
    @user = user
    mail(
      :from => 'notifications@restaurantintelligenceagency.com',
      :to   =>  user.email,
      :sent_on => Time.now,
      :subject => "Spoonfeed: #{discussion.poster.try :name} has invited you to a discussion"
      )
  end
  
  # sent to people recommended by another user
  def signup_recommendation(email, referring_user)
    @referring_user = referring_user
    mail(
      :from => 'notifications@restaurantintelligenceagency.com',
      :to   =>  email,
      :sent_on => Time.now,
      :subject => "Spoonfeed referral from #{referring_user.name}"
      )
  end
  
  # sent to users who request an invite for themselves
  def invitation_welcome(invite)
    @invitation = invite
    mail(
      :from => 'notifications@restaurantintelligenceagency.com',
      :to   =>  invite.email,
      :sent_on => Time.now,
      :subject => "Spoonfeed Invitation Request Received"
      )
  end
  
  # sent to admins to let them know a new invite has been requested
  def admin_invitation_notice(invite)
    @invitation = invite
    mail(
      :from => 'notifications@restaurantintelligenceagency.com',
      :to   =>  'info@restaurantintelligenceagency.com',
      :sent_on => Time.now,
      :subject => 'A new invitation has been requested'
      )
  end
  
  # sent to all users after their invite is accepted by an admin
  def new_user_invitation!(user, invitation_sender = nil)
    @user = user
    @invitation_sender = invitation_sender
    mail(
      :from => 'accounts@restaurantintelligenceagency.com',
      :to   =>  user.email,
      :sent_on => Time.now,
      :subject => "Your invitation to Spoonfeed has arrived!"
      )
  end
  
  # sent to the restaurant manager after a user joins and requests to be added to the restaurant as an employee
  def employee_request(restaurant, user)
    @recipient = restaurant.manager
    @user = user
    @restaurant = restaurant
    mail(
      :from => 'accounts@restaurantintelligenceagency.com',
      :to   =>  restaurant.manager.email,
      :sent_on => Time.now,
      :subject => "Spoonfeed: a new employee has joined"
      )
  end

  ##
  # Generic message: could be one of DirectMessage, etc.
  def message_notification(message, recipient, sender = nil)
    @message = message
    @recipient = recipient
    @sender = sender
    mail(
      :from => 'notifications@restaurantintelligenceagency.com',
      :to   =>  recipient.email,
      :sent_on => Time.now,
      :subject => "Spoonfeed: #{message.email_title} notification"
      )
  end

  ##
  # Generic message which can be 'answered': could be one of QOTD, etc.
  def answerable_message_notification(message, recipient)
    @message = message
    @recipient = recipient
    mail(
      :from => 'notifications@restaurantintelligenceagency.com',
      :to   =>  recipient.email_for_content,
      :reply_to => recipient.cloudmail_id(message)+"@#{CLOUDMAIL_DOMAIN}",
      :sent_on => Time.now,
      :subject => "Spoonfeed: #{message.email_title} notification"
      )
  end

  # Error email for answerable messages
  def answerable_message_error(message, recipient, error_text, allow_reply = true)
    @message = message
    @recipient = recipient
    @error_text = error_text
    @allow_reply = allow_reply
    mail(
      :from => 'notifications@restaurantintelligenceagency.com',
      :to   =>  recipient.email_for_content,
      :reply_to => recipient.cloudmail_id(message)+"@#{CLOUDMAIL_DOMAIN}",
      :sent_on => Time.now,
      :subject => "Spoonfeed: #{message.email_title} response error"
      )
  end

  ##
  # Comment on a generic message: could be one of DirectMessage, etc.
  def message_comment_notification(message, recipient, commenter = nil)
    @message = message
    @recipient = recipient
    @commenter = commenter
    mail(
      :from => 'notifications@restaurantintelligenceagency.com',
      :to   =>  recipient.email_for_content,
      :sent_on => Time.now,
      :subject => "Spoonfeed: #{message.email_title} comment notification"
      )
  end

  def newsletter_subscription_confirmation(subscriber)
    @subscriber = subscriber
    mail(
      :from => 'accounts@restaurantintelligenceagency.com',
      :to   =>  subscriber.email,
      :sent_on => Time.now,
      :subject => 'Confirm your Soapbox email newsletter subscription'
      )
  end

  def admin_notification(message, recipient)
    @message = message
    @recipient = recipient
    mail(
      :from => 'notifications@restaurantintelligenceagency.com'   ,
      :to   =>  "admin@restaurantintelligenceagency.com",
      :sent_on => Time.now,
      :subject => "An item is posted to Newsfeed notification "
      )
  end
    
  def cloudmailin_error(email)
    mail(
      :from => 'notifications@restaurantintelligenceagency.com'   ,
      :to   =>  email,
      :sent_on => Time.now,
      :subject => 'Spoonfeed: Email message error'
      )
  end


  def newsletter_preview_reminder(restaurant)
    @restaurant = restaurant
    mail(
      :from => 'notifications@restaurantintelligenceagency.com'   ,
      :to   =>  restaurant.manager.email,
      :sent_on => Time.now,
      :subject => 'Spoonfeed: Review your newsletter now'
      )
  end


  def add_keyword_request(restaurant,keyword)
    mail(
      :from => 'notifications@restaurantintelligenceagency.com'   ,
      :to   =>  "admin@restaurantintelligenceagency.com",
      :sent_on => Time.now,
      :subject => "Keyword Request from RESTAURANT NAME: #{restaurant} REQUESTED ITEM: #{keyword}"
      )
  end
  
  def send_mail_visitor(restaurant_visitors)
    @restaurant_visitors = restaurant_visitors
    mail(
      :from =>  'hal@restaurantintelligenceagency.com'   ,
      :to   =>  restaurant_visitors["employee"].email,
      :bcc =>   ['ellen@restaurantintelligenceagency.com','nishant.n@cisinlabs.com'],
      :sent_on => Time.now,
      :subject => "You have visitors!"
      )
  end
  
  def send_chef_user(restaurant_visitors)
    @restaurant_visitors = restaurant_visitors
    mail(
      :from =>  'hal@restaurantintelligenceagency.com'   ,
      :to   =>  restaurant_visitors["current_user"].email ,
      :bcc =>   ['ellen@restaurantintelligenceagency.com','nishant.n@cisinlabs.com'],
      :sent_on => Time.now,
      :subject => "Connect with media"
      )
  end

  def send_payment_error(name,message)
    @message = message
    mail(
      :from =>  'notifications@restaurantintelligenceagency.com'   ,
      :to   =>  "eric@restaurantintelligenceagency.com" ,
      :sent_on => Time.now,
      :subject => "Spoonfeed::Payment failed! :: #{name}"
      )
  end  

  def send_braintree_payment_error(name,link=nil)
    @name = name
    @link = link
    mail(
      :from =>  'notifications@restaurantintelligenceagency.com'   ,
      :to   =>  "eric@restaurantintelligenceagency.com" ,
      :sent_on => Time.now,
      :subject => "Spoonfeed: We are sorry!"
      )
  end  

  def request_info_mail(title,detail,user,restaurant,comment,subject,sender)
    @detail = detail
    @title = title
    @user = user
    @comment = comment
    email = restaurant.manager.try(:email) unless user.email == restaurant.manager.try(:email)
    mail(
      :from =>  sender.email   ,
      :to   =>  user.email  ,
      :cc =>  email  ,
      :sent_on => Time.now,
      :subject => "#{subject} Media Request via RIA" 
      )
  end  

  def export_press_kit(email,user,restaurant)
    @user = user
    @restaurant = restaurant
    mail(
      :from =>  user.email   ,
      :to   =>  email  ,
      :sent_on => Time.now,
      :subject => "#{user.username} sent you a link to their restaurant profile." 
      )
  end  

 

  def send_employee_claim_notification_mail(user,employee,restaurant)
    @employee = employee
    @user = user
    @restaurant = restaurant
    email = restaurant.manager.try(:email) unless user.email == restaurant.manager.try(:email)
    mail(
      :from =>  'notifications@restaurantintelligenceagency.com' ,
      :to   =>  user.email   ,
      :cc => email ,
      :sent_on => Time.now,
      :subject => "#{subject} Employee Claim Notification Mail via RIA" 
      )
  end


  def export_press_kit_for_media(email,user,restaurant)
    @user = user
    @restaurant = restaurant
    mail(
      :from =>  user.email ,
      :to   =>  email   ,
      :sent_on => Time.now,
      :subject => "#{user.username} sent you a link to their restaurant profile." 
      )
  end  

  def send_otm_keyword_notification(current_user,otm_keyword_name)
    @user = current_user
    @keyword = otm_keyword_name
    mail(
      :from =>  'notifications@restaurantintelligenceagency.com' ,
      :to   =>  ['ellen@restaurantintelligenceagency.com' ,'nishant.n@cisinlabs.com']  ,
      :sent_on => Time.now,
      :subject =>  "Otm Keyword Not Found"
      )
  end 

  def log_file msg , subject="Log File!" ,to='nishant.n@cisinlabs.com'
    @msg = msg
    mail(
      :from =>  'notifications@restaurantintelligenceagency.com' ,
      :to   =>  to  ,
      :sent_on => Time.now,
      :subject =>  subject
      )
  end  

  def request_profile_update(restaurant,employee)
    @restaurant = restaurant
    @employee = employee
    mail(
      :from =>  'notifications@restaurantintelligenceagency.com' ,
      :to   =>  employee.email  ,
      :bcc  =>  ['ellen@restaurantintelligenceagency.com' ,'nishant.n@cisinlabs.com'],
      :sent_on => Time.now,
      :subject =>  "Request from Journalist"
      )
  end 

  def send_user_alert_for_payment_declined_email restaurant
    @restaurant = restaurant
    mail(
      :from =>  'notifications@restaurantintelligenceagency.com' ,
      :to   =>  ['eric@restaurantintelligenceagency.com' ,'nishant.n@cisinlabs.com'] ,
      #:bcc  =>  ['eric@restaurantintelligenceagency.com' ,'nishant.n@cisinlabs.com'] #restaurant.manager.email,
      :sent_on => Time.now,
      :subject =>  "Update account payment information"
      )
  end 

end



