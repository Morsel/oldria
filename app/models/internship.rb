# == Schema Information
# Schema version: 20100826162154
#
# Table name: internships
#
#  id            :integer         not null, primary key
#  establishment :string(255)
#  supervisor    :string(255)
#  start_date    :date
#  end_date      :date
#  comments      :text
#  profile_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Internship < ActiveRecord::Base
  
  belongs_to :profile
  
  validates_presence_of :establishment, :supervisor, :start_date, :profile_id
end
