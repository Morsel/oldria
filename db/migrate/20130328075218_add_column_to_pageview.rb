#encoding: utf-8 
class AddColumnToPageview < ActiveRecord::Migration
 def self.up
 	  add_column :page_views, :page_id, :integer
    add_column :page_views, :page_type, :string
  end

  def self.down
    remove_column :page_views, :page_type
    remove_column :page_views, :page_id
  end
end
