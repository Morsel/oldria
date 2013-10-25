# == Schema Information
# Schema version: 20120217190417
#
# Table name: restaurant_roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  category   :string(255)
#

class RestaurantRole < ActiveRecord::Base

  has_many :employments
  has_many :employees, :through => :employments
  has_many :question_roles, :dependent => :destroy
  has_many :profile_questions, :through => :question_roles

  attr_accessible :category,:name

  validates_presence_of :name

  default_scope :order => "#{table_name}.name ASC"
  scope :with_employments, :joins => :employments, :group => "#{table_name}.id"
 
  def self.categories
    all.map(&:category).uniq.reject { |c| c.blank? }
  end

end
