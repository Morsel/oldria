#encoding: utf-8 
class AddAdminBoolToMediaRequests < ActiveRecord::Migration
  def self.up
    add_column :media_requests, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :media_requests, :admin
  end
end
