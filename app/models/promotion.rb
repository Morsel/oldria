# == Schema Information
# Schema version: 20110505222330
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
#

class Promotion < ActiveRecord::Base

  belongs_to :promotion_type

end
