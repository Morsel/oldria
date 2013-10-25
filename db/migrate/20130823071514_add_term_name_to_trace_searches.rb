#encoding: utf-8 
class AddTermNameToTraceSearches < ActiveRecord::Migration
  def self.up
    add_column :trace_searches, :term_name, :string
  end

  def self.down
    remove_column :trace_searches, :term_name
  end
end
