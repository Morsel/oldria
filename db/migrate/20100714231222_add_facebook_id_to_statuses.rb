#encoding: utf-8 
class AddFacebookIdToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :facebook_id, :integer
  end

  def self.down
    remove_column :statuses, :facebook_id
  end
end
