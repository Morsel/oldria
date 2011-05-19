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

  validates_presence_of :promotion_type_id, :details, :start_date, :restaurant_id

end
