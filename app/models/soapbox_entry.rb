# == Schema Information
# Schema version: 20100721223109
#
# Table name: soapbox_entries
#
#  id                 :integer         not null, primary key
#  published_at       :datetime
#  featured_item_id   :integer
#  featured_item_type :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class SoapboxEntry < ActiveRecord::Base
  belongs_to :featured_item, :polymorphic => true

  default_scope :order => "#{table_name}.published_at DESC"

  named_scope :qotd, :conditions => { :featured_item_type => 'Admin::Qotd' }
  named_scope :trend_question, :conditions => { :featured_item_type => 'TrendQuestion' }

  named_scope :published, lambda {{ :conditions => ['published_at <= ?', Time.zone.now] }}

  named_scope :recent,
              :limit => 5,
              :offset => 1

  def title
    featured_item.title
  end

  def comments
    featured_item.comments(true).select {|c| c.employment && c.employment.prefers_post_to_soapbox }
  end

  class << self
    def secondary_feature
      featured_item_with_offset(1)
    end

    def main_feature
      featured_item_with_offset(0)
    end

    def main_feature_comments(limit = 8)
      featured_item_comments_with_offset(0)[0...limit]
    end

    def secondary_feature_comments(limit = 8)
      featured_item_comments_with_offset(1)[0...limit]
    end

    private

    def featured_item_comments_with_offset(offset = 0)
      featured_item_with_offset(offset).comments(true).select {|c| c.employment && c.employment.prefers_post_to_soapbox }
    end

    def featured_item_with_offset(offset = 0)
      published.first(:include => :featured_item, :offset => offset).try(:featured_item)
    end
  end

end
