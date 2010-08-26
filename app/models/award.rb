# == Schema Information
# Schema version: 20100825200638
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

  validates_presence_of :name, :year_won, :year_nominated
  validates_format_of :year_won, :year_nominated, :with => /^(\d){4}+$/
end
