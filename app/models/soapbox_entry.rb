# == Schema Information
# Schema version: 20120221182030
#
# Table name: soapbox_entries
#
#  id                 :integer         not null, primary key
#  published_at       :datetime
#  featured_item_id   :integer
#  featured_item_type :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  published          :boolean         default(TRUE)
#  daily_feature      :boolean         default(FALSE)
#  description        :text
#

class SoapboxEntry < ActiveRecord::Base

  include ActionController::UrlWriter
  default_url_options[:host] = DEFAULT_HOST

  belongs_to :featured_item, :polymorphic => true

  default_scope :order => "#{table_name}.published_at DESC"

  named_scope :qotd, :conditions => { :featured_item_type => 'Admin::Qotd' }
  named_scope :trend_question, :conditions => { :featured_item_type => 'TrendQuestion' }

  named_scope :published, lambda {
    { :conditions => ['published_at <= ? AND published = ?', Time.zone.now, true] }
  }

  named_scope :recent,
              :limit => 5,
              :offset => 1

  named_scope :daily_feature, :conditions => { :daily_feature => true }, :order => "updated_at DESC"

  def title
    featured_item.title
  end

  def display_message
    featured_item.display_message
  end

  def comments
    featured_item.comments(false)
  end
  
  def published?
    published == true && published_at <= Time.zone.now
  end
  
  def upcoming?
    published == true && published_at > Time.zone.now
  end

  def latest_answer
    featured_item.last_comment
  end

  def bitly_link
    client = Bitly.new(BITLY_CONFIG['username'], BITLY_CONFIG['api_key'])
    client.shorten(soapbox_soapbox_entry_url(self)).short_url
  rescue => e
    Rails.logger.error("Bit.ly error: #{e.message}")
    soapbox_soapbox_entry_url(self)
  end

  class << self
    def main_feature
      featured_item_with_offset(0)
    end

    def main_feature_comments(limit = 6)
      featured_item_comments_with_offset(0)[0...limit]
    end

    def secondary_feature
      featured_item_with_offset(1)
    end

    def secondary_feature_comments(limit = 6)
      featured_item_comments_with_offset(1)[0...limit]
    end

    private

    def featured_item_with_offset(offset = 0)
      published.daily_feature.first(:include => :featured_item, :offset => offset).try(:featured_item)
    end

    def featured_item_comments_with_offset(offset = 0)
      featured_item_with_offset(offset).comments(true)
    end

  end

end

