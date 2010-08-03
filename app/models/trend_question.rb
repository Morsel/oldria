# == Schema Information
# Schema version: 20100409221445
#
# Table name: trend_questions
#
#  id                   :integer         not null, primary key
#  subject              :string(255)
#  body                 :text
#  scheduled_at         :datetime
#  expired_at           :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  employment_search_id :integer
#

class TrendQuestion < ActiveRecord::Base
  acts_as_readable
  belongs_to :employment_search

  has_many :admin_discussions, :as => :discussionable, :dependent => :destroy
  has_many :restaurants, :through => :admin_discussions

  has_one :soapbox_entry, :as => :featured_item

  named_scope :by_scheduled_date, :order => "#{table_name}.scheduled_at desc"
  named_scope :by_subject, :order => "#{table_name}.subject asc"

  before_save :update_restaurants_from_search_criteria

  def self.title
    "Trend Question"
  end

  def inbox_title
    self.class.title
  end

  def message
    [subject, body].compact.join(': ')
  end

  def update_restaurants_from_search_criteria
    self.restaurant_ids = employment_search.restaurant_ids
  end

  def viewable_by?(employment)
    return false unless employment
    employment.employee == employment.restaurant.try(:manager) ||
    employment.omniscient? ||
    employment_search.employments.include?(employment)
  end

  def reply_count
    admin_discussions.with_replies.count
  end

  def comments_count
    admin_discussions.sum(:comments_count)
  end

  def self.on_soapbox_with_response_from_user(user = nil)
    return [] unless user
    self.all(:joins => [:soapbox_entry, {:admin_discussions => :comments}], :conditions => ['comments.user_id = ?', user.id], :group => 'trend_questions.id')
  end

  def comments(deep_includes = false)
    includes = deep_includes ? {:comments => {:user => :employments}} : :comments
    admin_discussions.with_replies.all(:include => includes).map(&:comments).flatten
  end

  def title
    self.class.title
  end
end
