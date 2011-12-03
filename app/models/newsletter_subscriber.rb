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
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "is not a valid email address"
  validate :not_a_user

  private

  def not_a_user
    if User.find_by_email(email).present?
      errors.add(:email, "is already signed up")
      false
    end
  end

end
