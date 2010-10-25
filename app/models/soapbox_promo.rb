class SoapboxPromo < ActiveRecord::Base
  
  validates_presence_of :title, :body
  
end

# == Schema Information
#
# Table name: soapbox_promos
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  link       :string(255)
#

