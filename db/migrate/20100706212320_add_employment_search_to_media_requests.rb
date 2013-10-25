#encoding: utf-8 
class AddEmploymentSearchToMediaRequests < ActiveRecord::Migration
  def self.up
    add_column :media_requests, :employment_search_id, :integer
  end

  def self.down
    remove_column :media_requests, :employment_search_id
  end
end
