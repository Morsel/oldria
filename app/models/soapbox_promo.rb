class SoapboxPromo < ActiveRecord::Base
  
  validates_presence_of :title, :body
  
end

# == Schema Information
# Schema version: 20101022194902
#
# Table name: soapbox_promos
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  link       :string(255)
#  position   :integer
#

