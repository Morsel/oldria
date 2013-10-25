#encoding: utf-8 
class AddPublicationToMediaRequests < ActiveRecord::Migration
  def self.up
    add_column :media_requests, :publication, :string
  end

  def self.down
    remove_column :media_requests, :publication
  end
end
