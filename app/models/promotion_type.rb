# == Schema Information
# Schema version: 20110913204942
#
# Table name: promotion_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PromotionType < ActiveRecord::Base

  has_many :promotions

  named_scope :used_by_current_promotions, :joins => :promotions,
    :conditions => ["promotions.end_date >= ? OR (promotions.start_date >= ? AND promotions.end_date IS NULL)", Date.today, Date.today]

  named_scope :from_premium_restaurants, lambda {
    { :joins => { :promotions => { :restaurant => :subscription }},
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
  }

end
