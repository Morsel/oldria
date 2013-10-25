#encoding: utf-8 
class CreateMetroAreaUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :metropolitan_areas_users, :id => false do |t|
      t.integer :user_id
      t.integer :metropolitan_area_id
    end
    
    add_index :metropolitan_areas_users, :user_id
    add_index :metropolitan_areas_users, :metropolitan_area_id
  end

  def self.down
    drop_table :metropolitan_areas_users
  end
end
