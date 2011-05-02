# == Schema Information
# Schema version: 20110412173344
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
#  daily_feature      :boolean
#

class SoapboxEntry < ActiveRecord::Base
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

  def comments
    featured_item.comments(true).select {|c| c.show_on_soapbox? }
  end
  
  def published?
    published == true && published_at <= Time.zone.now
  end
  
  def upcoming?
    published == true && published_at > Time.zone.now
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
      featured_item_with_offset(offset).comments(true).select {|c| c.employment && c.employment.post_to_soapbox }
    end

  end

end
