# == Schema Information
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
#  opt_out              :boolean         default(FALSE)
#  password_hash        :string(255)
#  password_salt        :string(255)
#

class NewsletterSubscriber < ActiveRecord::Base
  acts_as_authentic
  include ActionView::Helpers::TextHelper  
  include ActionDispatch::Routing::UrlFor
  default_url_options[:host] = DEFAULT_HOST

  has_many :newsletter_subscriptions, :dependent => :destroy
  belongs_to :user

  validates_presence_of :email
  validates_uniqueness_of :email, :message => "has already registered"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "is not a valid email address", :allow_blank => true
  validate :not_a_user

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create

  attr_accessor :password, :password_confirmation
  attr_protected :password_hash, :password_salt

  before_save :encrypt_password
  after_create :send_confirmation
  after_update :update_mailchimp

  scope :confirmed, {
    :conditions => "confirmed_at IS NOT NULL"
  }
  def confirm!
    self.update_attribute(:confirmed_at, Time.now)
  end

  def confirmation_token
    Digest::MD5.hexdigest(id.to_s + created_at.to_s)
  end

  def confirmed?
    confirmed_at.present?
  end

  def self.build_from_registration(params)
    random_password = Array.new(10).map { (65 + rand(58)).chr }.join
    new(:first_name => params[:first_name],
        :last_name => params[:last_name],
        :email => params[:email],
        :password => random_password,
        :password_confirmation => random_password)
  end

  def self.create_from_user(u)
    subscriber = new(:first_name => u.first_name,
                     :last_name => u.last_name,
                     :email => u.email,
                     :user_id => u.id,
                     :confirmed_at => Time.now)
    subscriber.save(false)
    subscriber
  end

  def update_from_user(u)
    update_attributes(:first_name => u.first_name,
                      :last_name => u.last_name,
                      :email => u.email)
  end

  def self.authenticate(email, password)
    subscriber = find_by_email(email)
    if subscriber && subscriber.password_hash == BCrypt::Engine.hash_secret(password, subscriber.password_salt)
      subscriber
    else
      nil
    end
  end

  def has_subscription(restaurant)
    NewsletterSubscription.exists?(:newsletter_subscriber_id => self.id, :restaurant_id => restaurant.id)
  end

  def deliver_soapbox_password_reset_instructions!
    reset_perishable_token!
    UserMailer.password_reset_instructions_for_soapbox(self).deliver
  end

  private

  def not_a_user
    if !user.present? && User.find_by_email(email).present?
      errors.add(:email, "is already signed up for Spoonfeed. Log in to manage your settings there.")
      false
    end
  end

  def send_confirmation
    UserMailer.newsletter_subscription_confirmation(self).deliver
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def update_mailchimp
    if self.confirmed?
      mc = MailchimpConnector.new
      if self.opt_out?
        mc.client.list_unsubscribe(:id => mc.mailing_list_id, :email_address => email)
      else
        groupings = if receive_soapbox_news?
          { :name => "Your Interests", :groups => "National Newsletter" }
        else
          { :name => "Your Interests", :groups => "" }
        end
        mc.client.list_subscribe(:id => mc.mailing_list_id, :email_address => email, :update_existing => true, :double_optin => false,
                                 :merge_vars => { :fname => first_name, :lname => last_name, :groupings => [groupings] })
      end
    end
  end

end

