#encoding: utf-8 
class CreateRestaurantEmployeeRequests < ActiveRecord::Migration
  def self.up
    create_table :restaurant_employee_requests do |t|
      t.integer :restaurant_id
      t.integer :employee_id
      t.datetime :deleted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :restaurant_employee_requests
  end
end
