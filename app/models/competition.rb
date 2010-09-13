# == Schema Information
# Schema version: 20100826001044
#
# Table name: competitions
#
#  id         :integer         not null, primary key
#  profile_id :integer
#  name       :string(255)
#  place      :string(255)
#  year       :integer
#  created_at :datetime
#  updated_at :datetime
#

class Competition < ActiveRecord::Base
  
  belongs_to :profile
  
  validates_presence_of :name, :place, :year, :profile_id
  
end
