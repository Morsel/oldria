# == Schema Information
# Schema version: 20120217190417
#
# Table name: specialties
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

class Specialty < ActiveRecord::Base

  has_many :profile_specialties
  has_many :profiles, :through => :profile_specialties
  has_many :trace_keywords, :as => :keywordable
  has_many :trace_searches, :as => :keywordable
  
  validates_presence_of :name

  scope :with_profiles,
    :joins => :profiles,
    :group => "#{table_name}.id"

end
