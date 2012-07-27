# == Schema Information
# Schema version: 20120726233422
#
# Table name: newsletter_subscribers
#
#  id                   :integer         not null, primary key
#  email                :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  confirmed_at         :datetime
#  first_name           :string(255)
#  last_name            :string(255)
#  receive_soapbox_news :boolean         default(TRUE)
#  opt_out              :boolean
#

class NewsletterSubscriber < ActiveRecord::Base

  validates_presence_of :email
  validates_uniqueness_of :email, :message => "has already registered"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "is not a valid email address", :allow_blank => true
  validate :not_a_user

  after_create :send_confirmation

  def confirm!
    self.update_attribute(:confirmed_at, Time.now)
  end

  def confirmation_token
    Digest::MD5.hexdigest(id.to_s + created_at.to_s)
  end

  def self.build_from_registration(params)
    new(:first_name => params[:first_name],
        :last_name => params[:last_name],
        :email => params[:email])
  end

  private

  def not_a_user
    if User.find_by_email(email).present?
      errors.add(:email, "is already signed up for Spoonfeed. Log in to manage your settings there.")
      false
    end
  end

  def send_confirmation
    UserMailer.send_later(:deliver_newsletter_subscription_confirmation, self)
    # UserMailer.deliver_newsletter_subscription_confirmation(self)
  end

end

