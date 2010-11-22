class Cookbook < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :title, :publisher, :published_on
end
