class Award < ActiveRecord::Base
  belongs_to :profile

  validates_presence_of :name, :year_won, :year_nominated
  validates_format_of :year_won, :year_nominated, :with => /^(\d){4}+$/
end
