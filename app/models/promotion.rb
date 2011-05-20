# == Schema Information
# Schema version: 20110517222623
#
# Table name: promotions
#
#  id                :integer         not null, primary key
#  promotion_type_id :integer
#  details           :text
#  link              :string(255)
#  start_date        :date
#  end_date          :date
#  date_description  :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  restaurant_id     :integer
#

# Restaurant events and promotions

class Promotion < ActiveRecord::Base

  belongs_to :promotion_type
  belongs_to :restaurant

  validates_presence_of :promotion_type, :details, :start_date, :restaurant_id
  validates_presence_of :end_date, :if => Proc.new { |promo| promo.date_description.present? },
      :message => "End date is required for repeating events"
  validates_length_of :details, :maximum => 1000

  named_scope :current, :order => "start_date DESC"

  named_scope :from_premium_restaurants, lambda {
    { :joins => { :restaurant => :subscription },
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
  }

  def title
    promotion_type.name
  end

  def restaurant_name
    restaurant.name
  end

end
