#encoding: utf-8 
class AddCountToTraceSearches < ActiveRecord::Migration
  def self.up
    #add_column :trace_searches, :count, :integer
  end

  def self.down
    remove_column :trace_searches, :count
  end
end
