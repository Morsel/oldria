#encoding: utf-8 
class AddPublicToEmployment < ActiveRecord::Migration
  def self.up
    add_column :employments, :public_profile, :boolean
  end

  def self.down
    remove_column :employments, :public_profile
  end
end
