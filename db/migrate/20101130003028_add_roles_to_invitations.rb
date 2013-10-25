#encoding: utf-8 
class AddRolesToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :restaurant_role_id, :integer
  end

  def self.down
    remove_column :invitations, :restaurant_role_id
  end
end
