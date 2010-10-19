# == Schema Information
# Schema version: 20101019162841
#
# Table name: soapbox_promos
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class SoapboxPromo < ActiveRecord::Base
  
  validates_presence_of :title, :body
  
end
