#encoding: utf-8 
class CreateDefaultEmployments < ActiveRecord::Migration
  def self.up
    create_table :default_employments do |t|
      t.integer :employee_id
      t.integer :restaurant_role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :default_employments
  end
end
