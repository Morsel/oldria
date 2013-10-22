# == Schema Information
# Schema version: 20120217190417
#
# Table name: profile_cuisines
#
#  id         :integer         not null, primary key
#  profile_id :integer
#  cuisine_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProfileCuisine < ActiveRecord::Base
  
  belongs_to :cuisine
  belongs_to :profile
  
  validates_presence_of :profile_id, :cuisine_id
  
  validates_uniqueness_of :cuisine_id, :scope => :profile_id, :message => "This cuisine is already on your profile"
  attr_accessible :profile_id, :cuisine_id
end
