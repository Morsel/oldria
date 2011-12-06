# == Schema Information
# Schema version: 20111201222932
#
# Table name: newsletter_subscribers
#
#  id         :integer         not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class NewsletterSubscriber < ActiveRecord::Base

  validates_presence_of :email
  validates_uniqueness_of :email, :message => "has already signed up for the newsletter"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "is not a valid email address", :allow_blank => true
  validate :not_a_user

  after_create :send_confirmation

  def confirm!
    self.update_attribute(:confirmed_at, Time.now)
  end

  private

  def not_a_user
    if User.find_by_email(email).present?
      errors.add(:email, "is already signed up")
      false
    end
  end

  def send_confirmation
    UserMailer.send_later(:deliver_newsletter_subscription_confirmation, self)
    # UserMailer.deliver_newsletter_subscription_confirmation(self)
  end

end
