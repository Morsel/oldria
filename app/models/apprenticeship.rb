# == Schema Information
# Schema version: 20110831230326
#
# Table name: apprenticeships
#
#  id            :integer         not null, primary key
#  establishment :string(255)
#  supervisor    :string(255)
#  year          :integer
#  comments      :text
#  profile_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Apprenticeship < ActiveRecord::Base
  
  belongs_to :profile
  
  validates_presence_of :establishment, :supervisor, :year, :profile_id
  
end
