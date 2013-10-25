#encoding: utf-8 
class AddFieldsToMediaRequests < ActiveRecord::Migration
  def self.up
    add_column :media_requests, :fields, :text
  end

  def self.down
    remove_column :media_requests, :fields
  end
end
