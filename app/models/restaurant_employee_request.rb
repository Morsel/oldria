class RestaurantEmployeeRequest < ActiveRecord::Base
	belongs_to :employee ,:class_name =>'User',:foreign_key =>"employee_id"
	belongs_to :restaurant 
	validates_presence_of :employee_id
	validates_presence_of :restaurant_id
	validates_uniqueness_of :employee_id, :scope => :restaurant_id ,:message=>"Request already been sent."
	attr_protected
end
