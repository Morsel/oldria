# == Schema Information
#
# Table name: promotions
#
#  id                      :integer         not null, primary key
#  promotion_type_id       :integer
#  details                 :text
#  link                    :string(255)
#  start_date              :date
#  end_date                :date
#  date_description        :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  restaurant_id           :integer
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  headline                :string(255)
#  post_to_twitter_at      :datetime
#  post_to_facebook_at     :datetime
#

# Restaurant events and promotions

class Promotion < ActiveRecord::Base

  include ActionDispatch::Routing::UrlFor
include Rails.application.routes.url_helpers
default_url_options[:host] = DEFAULT_HOST

  belongs_to :promotion_type
  belongs_to :restaurant
  has_many :trace_keywords, :as => :keywordable
  has_many :soapbox_trace_keywords, :as => :keywordable
  
  has_many :twitter_posts, :as => :source, :dependent => :destroy
  accepts_nested_attributes_for :twitter_posts, :limit => 3, :allow_destroy => true, :reject_if => TwitterPost::REJECT_PROC

  has_many :facebook_posts, :as => :source, :dependent => :destroy
  accepts_nested_attributes_for :facebook_posts, :limit => 3, :allow_destroy => true, :reject_if => FacebookPost::REJECT_PROC

  validates_presence_of :promotion_type, :details, :start_date, :restaurant_id, :headline
  validates_presence_of :end_date, :if => Proc.new { |promo| promo.date_description.present? },
      :message => "End date is required for repeating events"
  validate :details_word_count
  validates_length_of :headline, :maximum => 144

  after_create :send_newsfeed_newsletters

  # Attachments and validations
  has_attached_file :attachment,
                    :storage        => :s3,
                    :s3_credentials => "#{Rails.root}/config/environments/#{Rails.env}/amazon_s3.yml",
                    :path           => "#{Rails.env}/newsfeed_attachments/:id/:filename",
                    :bucket         => "spoonfeed",
                    :url            => ':s3_domain_url'

  VALID_CONTENT_TYPES = ["application/zip", "application/x-zip", "application/x-zip-compressed", "application/pdf", "application/x-pdf"]

  before_validation(:on => :save) do |file|
    if file.attachment_file_name.present? && (file.attachment_content_type == 'binary/octet-stream')
      mime_type = MIME::Types.type_for(file.attachment_file_name)
      file.attachment_content_type = mime_type.first.content_type if mime_type.first
    end
  end

  validate :content_type, :if => Proc.new { |promo| promo.attachment_file_name.present? }

  attr_accessible :post_to_twitter_at, :post_to_facebook_at,:promotion_type_id, :headline, :details, :link, :attachment,
   :start_date, :date_description,:end_date
   
  def content_type
    errors.add(:attachment, "needs to be converted to PDF") unless VALID_CONTENT_TYPES.include?(self.attachment_content_type)
  end
  # end of attachments section

  scope :current,
              :conditions => ["promotions.end_date >= ? OR (promotions.start_date >= ? AND promotions.end_date IS NULL)",
                              Date.today, Date.today],
              :order => "promotions.start_date ASC"

  scope :recently_posted,
              :conditions => ["promotions.end_date >= ? OR (promotions.start_date >= ? AND promotions.end_date IS NULL)",
                              Date.today, Date.today],
              :order => "promotions.created_at DESC"

  scope :from_premium_restaurants, lambda {
    { :joins => { :restaurant => :subscription },
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
  }

  scope :for_type, lambda { |type_id|
    { :conditions => { :promotion_type_id => type_id } }
  }

  def title
    promotion_type.try(:name)
  end

  def restaurant_name
    restaurant.name
  end

  def current?
    end_date.nil? ? start_date >= Date.today : end_date >= Date.today
  end

  def date_text
    text = start_date.to_formatted_s(:long)
    text << "- #{end_date.to_formatted_s(:long)}" if end_date.present?
    text << "- #{date_description}" if date_description.present?
    return text
  end

  def activity_name
    "Newsfeed item"
  end

  def bitly_link
    client = Bitly.new(BITLY_CONFIG['username'], BITLY_CONFIG['api_key'])
    client.shorten(soapbox_promotion_url(self)).short_url
  rescue => e
    Rails.logger.error("Bit.ly error: #{e.message}")
    soapbox_promotion_url(self)
  end

  def notify_newsfeed_request!      
     UserMailer.deliver_admin_notification(self, restaurant.manager)      
  end

  def twitter_message
    "#{truncate(self.headline, :length => 120)} #{self.bitly_link}"
  end

  def facebook_message
    "Newsfeed: #{self.title}"
  end

  def post_to_twitter(message=nil)
    message = message.blank? ? headline : message
    message = "#{truncate(message,:length => (135-self.bitly_link.length))} #{self.bitly_link}"
    restaurant.twitter_client.update(message)

  end

  def post_to_facebook(message=nil)
    message = message.blank? ? facebook_message : message
    post_attributes = {
      :message     => message,
      :link        => soapbox_promotion_url(self),
      :name        => headline,
      :description => Loofah::Helpers.strip_tags(details.gsub(/(<[^>]*>)|\r|\t/s) {" "}), 
      :picture => (restaurant.logo && restaurant.logo.attachment?) ? restaurant.logo.attachment.url(:medium) : nil
    }
    restaurant.post_to_facebook_page(post_attributes)
  end

  def edit_path(options={})
    edit_restaurant_promotion_path(restaurant, self, options)
  end

  def send_newsfeed_newsletters_mailchimp mc,conditions
    
      campaign_id = \
      mc.client.campaign_create(:type => "regular",
                                :options => { :list_id => mc.media_promotion_list_id,
                                              :subject => "#{self.promotion_type.try(:name)}: #{self.headline}",
                                              :from_email => "hal@restaurantintelligenceagency.com",
                                              :to_name => "*|FNAME|*",
                                              :from_name => "Restaurant Intelligence Agency",
                                              :generate_text => true },
                                 :segment_opts => { :match => "all",
                                                    :conditions => conditions},
                                :content => { :url => preview_restaurant_promotion_url(self.restaurant,self) })
      # send campaign
    mc.client.campaign_send_now(:cid => campaign_id)

  end  
  def send_newsfeed_newsletters_later

      mc = MailchimpConnector.new("RIA Newsfeed")       
      groups = mc.get_mpl_groups
      with_no_national = [{ :field => "WRITERTYPE",:op => "ne",:value => "National Writer"},  
        {:field=>"interests-#{groups['Promotions']['id']}",:op=>"one",:value=>self.promotion_type.try(:name)},
        {:field=>"interests-#{groups['SubscriberType']['id']}",:op=>"one",:value=>"Newsfeed"},
        {:field=>"METROAREAS",:op=>"like",:value=>self.restaurant.metropolitan_area_id}]

      with_national = [{ :field => "WRITERTYPE",:op => "eq",:value => "National Writer"},  
        {:field=>"interests-#{groups['Promotions']['id']}",:op=>"one",:value=>self.promotion_type.try(:name)},
        {:field=>"interests-#{groups['SubscriberType']['id']}",:op=>"one",:value=>"Newsfeed"}
        ]
       send_newsfeed_newsletters_mailchimp(mc,with_national) 
       send_newsfeed_newsletters_mailchimp(mc,with_no_national)

  end

  private

  def details_word_count
    if details.split(" ").size > 1000
      errors.add(:details, "can't go over 1000 words")
    end
  end
 
  def send_newsfeed_newsletters
    send_later(:send_newsfeed_newsletters_later) if restaurant.premium_account?
  end 

  

end
