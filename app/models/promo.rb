# == Schema Information
# Schema version: 20101104213542
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
#

class Promo < ActiveRecord::Base
  
  validates_presence_of :title, :body
  
end
