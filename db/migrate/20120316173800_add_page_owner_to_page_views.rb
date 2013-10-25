#encoding: utf-8 
class AddPageOwnerToPageViews < ActiveRecord::Migration
  def self.up
    add_column :page_views, :page_owner_id, :integer
    add_column :page_views, :page_owner_type, :string
  end

  def self.down
    remove_column :page_views, :page_owner_type
    remove_column :page_views, :page_owner_id
  end
end
