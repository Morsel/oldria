# == Schema Information
#
# Table name: account_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class AccountType < ActiveRecord::Base
  has_many :users
  attr_accessible :name
end
