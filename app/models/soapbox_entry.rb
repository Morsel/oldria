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

  named_scope :qotd, :conditions => { :featured_item_type => 'Admin::Qotd' }
  named_scope :trend_question, :conditions => { :featured_item_type => 'TrendQuestion' }
  
  named_scope :published, 
              :conditions => ['published_at < ?', Time.zone.now], 
              :order => "published_at desc"
              
  named_scope :recent,
              :limit => 5,
              :offset => 1,
              :order => "published_at desc"

  def title
    featured_item.title
  end
  
  def self.featured_trend_question
    trend_question.published.first(:include => :featured_item).try(:featured_item)
  end
  
  def self.featured_trend_question_comments
    # FIXME: filter to authorized users/employments only - rejecting admins because they break the comment partial
    self.featured_trend_question.comments(true).reject { |c| c.user.admin? }
  end
  
  def self.featured_qotd
    qotd.published.first(:include => :featured_item).try(:featured_item)
  end
  
  def self.featured_qotd_comments
    self.featured_qotd.conversations_with_replies.map(&:comments).flatten.reject { |c| c.user.admin? }
  end

end
