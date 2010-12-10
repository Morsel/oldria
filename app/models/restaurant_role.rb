# == Schema Information
# Schema version: 20100827181841
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
  has_many :question_roles, :as => :responder, :dependent => :destroy
  has_many :profile_questions, :through => :question_roles

  validates_presence_of :name
  
  default_scope :order => "#{table_name}.category ASC, #{table_name}.name ASC"

  named_scope :with_employments, :joins => :employments, :group => "#{table_name}.id"

  def self.categories
    all.map(&:category).uniq.reject { |c| c.blank? }
  end

end
