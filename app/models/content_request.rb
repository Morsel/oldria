# == Schema Information
# Schema version: 20100412193718
#
# Table name: content_requests
#
#  id                   :integer         not null, primary key
#  subject              :string(255)
#  body                 :text
#  scheduled_at         :datetime
#  expired_at           :datetime
#  employment_search_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class ContentRequest < ActiveRecord::Base
  belongs_to :employment_search
  has_many :admin_discussions, :as => :discussionable
  has_many :restaurants, :through => :admin_discussions

  named_scope :by_scheduled_date, :order => "#{table_name}.scheduled_at ASC"

  before_save :update_restaurants_from_search_criteria

  def self.title
    "Question from RIA"
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

end
