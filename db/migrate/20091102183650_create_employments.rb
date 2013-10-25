#encoding: utf-8 
class CreateEmployments < ActiveRecord::Migration
  def self.up
    create_table :employments do |t|
      t.integer :employee_id
      t.integer :restaurant_id

      t.timestamps
    end
  end

  def self.down
    drop_table :employments
  end
end
