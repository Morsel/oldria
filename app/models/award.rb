# == Schema Information
# Schema version: 20120217190417
#
# Table name: awards
#
#  id             :integer         not null, primary key
#  profile_id     :integer
#  name           :string(255)
#  year_won       :string(4)       default(""), not null
#  year_nominated :string(4)       default(""), not null
#  created_at     :datetime
#  updated_at     :datetime
#

class Award < ActiveRecord::Base
  belongs_to :profile

  validates_presence_of :name
  validates_presence_of :year_won, :if => Proc.new { |a| a.year_nominated.blank? }
  validates_presence_of :year_nominated, :if => Proc.new { |a| a.year_won.blank? }
  attr_accessible :name, :year_won, :year_nominated
end
