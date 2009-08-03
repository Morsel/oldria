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

end
