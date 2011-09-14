# == Schema Information
# Schema version: 20110831230326
#
# Table name: site_activities
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class SiteActivity < ActiveRecord::Base

  validates_presence_of :description

end
