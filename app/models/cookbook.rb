# == Schema Information
# Schema version: 20120217190417
#
# Table name: cookbooks
#
#  id           :integer         not null, primary key
#  title        :string(255)
#  publisher    :string(255)
#  published_on :datetime
#  profile_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Cookbook < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :title, :publisher, :published_on
  attr_accessible :title, :publisher, :published_on
end
