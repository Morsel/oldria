# == Schema Information
# Schema version: 20120217190417
#
# Table name: james_beard_regions
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class JamesBeardRegion < ActiveRecord::Base
  has_many :restaurants
  has_many :profiles
  has_many :users, :through => :profiles
  has_many :trace_searches, :as => :keywordable

  validates_presence_of :name
  validates_presence_of :description

  scope :with_restaurants,
    :joins => :restaurants,
    :conditions => 'restaurants.deleted_at IS NULL',
    :group => "#{table_name}.id"

  scope :with_profiles,
    :joins => :profiles,
    :group => "#{table_name}.id"

  def name_and_description(show_parentheses = true)
    @name_and_description ||= begin
      desc = (show_parentheses ? "(#{description})" : description)
      "#{name} #{desc}"
    end
  end
  
  # Formtastic Labels
  alias :to_label :name_and_description
  
end
