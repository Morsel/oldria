# == Schema Information
# Schema version: 20110831230326
#
# Table name: restaurant_answers
#
#  id                     :integer         not null, primary key
#  restaurant_question_id :integer
#  answer                 :text
#  restaurant_id          :integer
#  created_at             :datetime
#  updated_at             :datetime
#

class RestaurantAnswer < ActiveRecord::Base

  belongs_to :restaurant_question
  belongs_to :restaurant

  validates_presence_of :answer, :restaurant_question_id, :restaurant_id
  validates_uniqueness_of :restaurant_question_id, :scope => :restaurant_id

  named_scope :from_premium_restaurants, lambda {
    {
      :joins => { :restaurant => :subscription },
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today]
    }
  }

end
