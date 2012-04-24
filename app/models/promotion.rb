# == Schema Information
# Schema version: 20120217190417
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
#

# Restaurant events and promotions

class Promotion < ActiveRecord::Base

  include ActionView::Helpers::TextHelper
  include ActionController::UrlWriter
  default_url_options[:host] = DEFAULT_HOST

  belongs_to :promotion_type
  belongs_to :restaurant

  validates_presence_of :promotion_type, :details, :start_date, :restaurant_id, :headline
  validates_presence_of :end_date, :if => Proc.new { |promo| promo.date_description.present? },
      :message => "End date is required for repeating events"
  validate :details_word_count
  validates_length_of :headline, :maximum => 144

  # Attachments and validations
  has_attached_file :attachment,
                    :storage        => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/environments/#{RAILS_ENV}/amazon_s3.yml",
                    :path           => "#{RAILS_ENV}/newsfeed_attachments/:id/:filename",
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

  def content_type
    errors.add(:attachment, "needs to be converted to PDF") unless VALID_CONTENT_TYPES.include?(self.attachment_content_type)
  end
  # end of attachments section

  named_scope :current,
              :conditions => ["promotions.end_date >= ? OR (promotions.start_date >= ? AND promotions.end_date IS NULL)",
                              Date.today, Date.today],
              :order => "promotions.start_date ASC"

  named_scope :recently_posted,
              :conditions => ["promotions.end_date >= ? OR (promotions.start_date >= ? AND promotions.end_date IS NULL)",
                              Date.today, Date.today],
              :order => "promotions.created_at DESC"

  named_scope :from_premium_restaurants, lambda {
    { :joins => { :restaurant => :subscription },
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
  }

  named_scope :for_type, lambda { |type_id|
    { :conditions => { :promotion_type_id => type_id } }
  }

  attr_accessor :post_to_twitter, :post_to_facebook_page
  after_create :crosspost

  def title
    promotion_type.name
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
  end

  private

  def crosspost
    if post_to_twitter == "1"
      restaurant.twitter_client.send_later(:update, "#{truncate(headline, :length => 120)} #{self.bitly_link}")
    end
    if post_to_facebook_page == "1"
      post_attributes = { :message     => "Newsfeed: #{title}",
                          :link        => soapbox_promotion_url(self),
                          :name        => headline,
                          :description => details }
      restaurant.send_later(:post_to_facebook_page, post_attributes)
    end
  end

  def details_word_count
    if details.split(" ").size > 1000
      errors.add(:details, "can't go over 1000 words")
    end
  end

end
