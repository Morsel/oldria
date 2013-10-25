# == Schema Information
# Schema version: 20120217190417
#
# Table name: promos
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  link       :string(255)
#  position   :integer
#  type       :string(255)
#  link_text  :string(255)
#

# Base class for front page promotions

class Promo < ActiveRecord::Base
  default_scope :order => 'position ASC'
  
  validates_presence_of :title, :body
  attr_accessible :title,:body,:link

end
