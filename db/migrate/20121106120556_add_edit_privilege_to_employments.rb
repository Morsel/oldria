#encoding: utf-8 
class AddEditPrivilegeToEmployments < ActiveRecord::Migration
  def self.up
    add_column :employments, :edit_privilege, :boolean
  end

  def self.down
    remove_column :employments, :edit_privilege
  end
end
