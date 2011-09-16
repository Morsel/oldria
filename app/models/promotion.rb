# == Schema Information
# Schema version: 20110913204942
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

  named_scope :current, :conditions => ["promotions.end_date >= ? OR (promotions.start_date >= ? AND promotions.end_date IS NULL)", Date.today, Date.today],
                        :order => "promotions.start_date ASC"

  named_scope :recently_posted, :conditions => ["promotions.end_date >= ? OR (promotions.start_date >= ? AND promotions.end_date IS NULL)", Date.today, Date.today],
                                :order => "promotions.created_at DESC"

  named_scope :from_premium_restaurants, lambda {
    { :joins => { :restaurant => :subscription },
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
  }

  named_scope :for_type, lambda { |type_id|
    { :conditions => { :promotion_type_id => type_id } }
  }

  def title
    promotion_type.name
  end

  def restaurant_name
    restaurant.name
  end

  def current?
    end_date.nil? ? start_date >= Date.today : end_date >= Date.today
  end

end
