# == Schema Information
# Schema version: 20100805194513
#
# Table name: profiles
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  birthday   :date
#  job_start  :date
#  cellnumber :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Profile < ActiveRecord::Base
  REJECT_ALL_BLANK_PROC = proc { |attributes| attributes.all? { |_, value| value.blank? } }

  belongs_to :user
  validates_uniqueness_of :user_id
  has_many :profile_restaurants

  accepts_nested_attributes_for :profile_restaurants, :reject_if => REJECT_ALL_BLANK_PROC

end
