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
  include ActionController::UrlWriter
  default_url_options[:host] = DEFAULT_HOST

  has_many :newsletter_subscriptions, :dependent => :destroy
  belongs_to :user

  belongs_to :digest_diner
  accepts_nested_attributes_for :digest_diner
  has_many :regional_writers, :dependent => :destroy, :foreign_key => 'newsletter_subscriber_id'
  has_many :metropolitan_areas_writers, :dependent => :destroy,:foreign_key => 'newsletter_subscriber_id'

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
  #after_update :update_mailchimp

  named_scope :confirmed, {
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

  # 2 = Regional, 3 = Local
  def delete_other_writers  
    if digest_diner_id == 1
      metropolitan_areas_writers.find(:all,:conditions=>"area_writer_type = 'DigestDiner'").map(&:destroy)      
      regional_writers.find(:all,:conditions=>"regional_writer_type = 'DigestDiner'").map(&:destroy)
    elsif  digest_diner_id == 2      
      metropolitan_areas_writers.find(:all,:conditions=>"area_writer_type = 'DigestDiner'").map(&:destroy)      
    elsif  digest_diner_id == 3      
      regional_writers.find(:all,:conditions=>"regional_writer_type = 'DigestDiner'").map(&:destroy)
    end 
  end

  def send_newsletters_to_diner
    for newsletter_subscriber in NewsletterSubscriber.all
      @arrMedia=[]    
      @arrMedia.push(newsletter_subscriber.newsletter_subscriptions.map(&:restaurant))
      @arrMedia.push(newsletter_subscriber.get_digest_subscription)
      @arrMedia.flatten!
      unless NewsletterSubscription.menu_items(@arrMedia).blank? && NewsletterSubscription.promotions(@arrMedia).blank?
        newsletter_subscriber.send_later(:send_newsletter_to_diner_subscribers,newsletter_subscriber) if (!newsletter_subscriber.opt_out) && (!["Sun","Sat"].include?(Date::ABBR_DAYNAMES[Date.today.wday]))
      end
    end
  end

  def get_digest_subscription
    @restaurants = []    
    if digest_diner.name == "National Diner"
      @restaurants = Restaurant.all
    elsif digest_diner.name == "Regional Diner"
      @restaurants = digest_diner.find_diner_regional_writers(self).map(&:james_beard_region).map(&:restaurants)
    else
      @restaurants = digest_diner.find_diner_metropolitan_areas_writers(self).map(&:metropolitan_area).map(&:restaurants)
    end unless digest_diner.blank?
    @restaurants.flatten.compact.uniq
  end  

  def send_newsletter_to_diner_subscribers subscriber
    if !subscriber.opt_out 
      begin
        @arrMedia=[]    
        @arrMedia.push(subscriber.newsletter_subscriptions.map(&:restaurant))
        @arrMedia.push(subscriber.get_digest_subscription)
        @arrMedia.flatten!

        @basic_restarurants_menu_items = []
        @basic_restarurants_promotions = []    

        @menu_items = @menus = @restaurantAnswers = @promotions = []
        unless(@arrMedia.blank?)
           @arrMedia.each do |restaurant|
             @basic_restarurants_menu_items << restaurant if !restaurant.premium_account? && !restaurant.menu_items.find(:all,:conditions=>["created_at >= ? OR updated_at >= ?",1.day.ago.beginning_of_day,1.day.ago.beginning_of_day]).blank?
           end
           @arrMedia.each do |restaurant|
             @basic_restarurants_promotions << restaurant if !restaurant.premium_account? && !restaurant.promotions.find(:all,:conditions=>["created_at >= ? OR updated_at >= ?",1.day.ago.beginning_of_day,1.day.ago.beginning_of_day]).blank?
           end

          @arrMedia = @arrMedia - @basic_restarurants_menu_items - @basic_restarurants_promotions

          @menu_items = NewsletterSubscription.menu_items(@arrMedia)   
          @menus = NewsletterSubscription.newsletter_menus(@arrMedia)  
          @fact_sheets = NewsletterSubscription.fact_sheets(@arrMedia)  
          @photos = NewsletterSubscription.photos(@arrMedia)  
          @promotions = NewsletterSubscription.promotions(@arrMedia)
        end
        diner_user_subscribers = {
          "subscriber" => subscriber,
          "basic_restarurants_menu_items" =>@basic_restarurants_menu_items,
          "basic_restarurants_promotions" => @basic_restarurants_promotions,
          "menu_items" => @menu_items,
          "menus" =>@menus,
          "restaurantAnswers" => @restaurantAnswers,
          "promotions" => @promotions,
          "arrMedia" => @arrMedia,
          "fact_sheets" => @fact_sheets,
          "photos" => @photos
        }
        UserMailer.deliver_send_diner_subscriber(diner_user_subscribers)
      rescue Exception => e
        UserMailer.deliver_log_file("User : #{subscriber.email} Error: #{e.message}","Exception")
      end  
    end  

  def deliver_soapbox_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions_for_soapbox(self)
  end

  private

  def not_a_user
    if !user.present? && User.find_by_email(email).present?
      errors.add(:email, "is already signed up for Spoonfeed. Log in to manage your settings there.")
      false
    end
  end

  def send_confirmation
    UserMailer.send_later(:deliver_newsletter_subscription_confirmation, self)
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

