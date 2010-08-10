# == Schema Information
# Schema version: 20100810184557
#
# Table name: question_roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class QuestionRole < ActiveRecord::Base

  validates_presence_of :name
  has_and_belongs_to_many :restaurant_roles
  
end
