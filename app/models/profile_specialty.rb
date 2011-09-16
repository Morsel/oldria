# == Schema Information
# Schema version: 20110913204942
#
# Table name: profile_specialties
#
#  id           :integer         not null, primary key
#  profile_id   :integer
#  specialty_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class ProfileSpecialty < ActiveRecord::Base

  belongs_to :profile
  belongs_to :specialty
  
end
