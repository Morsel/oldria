# == Schema Information
# Schema version: 20110517222623
#
# Table name: promotion_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PromotionType < ActiveRecord::Base

  has_many :promotions

  named_scope :used_by_promotions, :joins => :promotions

end
