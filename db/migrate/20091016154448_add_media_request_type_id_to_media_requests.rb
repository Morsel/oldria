#encoding: utf-8 
class AddMediaRequestTypeIdToMediaRequests < ActiveRecord::Migration
  def self.up
    change_table :media_requests do |t|
      t.references :media_request_type
    end
  end

  def self.down
    change_table :media_requests do |t|
      t.remove :media_request_type_id
    end
  end
end
