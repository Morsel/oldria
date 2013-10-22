# == Schema Information
# Schema version: 20120217190417
#
# Table name: site_activities
#
#  id           :integer         not null, primary key
#  description  :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  creator_id   :integer
#  creator_type :string(255)
#  content_id   :integer
#  content_type :string(255)
#

class SiteActivity < ActiveRecord::Base

  belongs_to :creator, :polymorphic => true
  belongs_to :content, :polymorphic => true

  validates_presence_of :description

  attr_accessible  :description, :creator, :content

end
