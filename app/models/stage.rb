# == Schema Information
# Schema version: 20100826190657
#
# Table name: stages
#
#  id            :integer         not null, primary key
#  establishment :string(255)
#  expert        :string(255)
#  start_date    :date
#  end_date      :date
#  comments      :text
#  profile_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Stage < ActiveRecord::Base
  
  belongs_to :profile
  
  validates_presence_of :establishment, :expert, :start_date, :profile_id
end
