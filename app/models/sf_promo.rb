# == Schema Information
# Schema version: 20110913204942
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

class SfPromo < Promo
end
