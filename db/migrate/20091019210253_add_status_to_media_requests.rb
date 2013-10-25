#encoding: utf-8 
class AddStatusToMediaRequests < ActiveRecord::Migration
  def self.up
    add_column :media_requests, :status, :string
  end

  def self.down
    remove_column :media_requests, :status
  end
end
