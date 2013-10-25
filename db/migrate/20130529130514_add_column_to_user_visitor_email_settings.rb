#encoding: utf-8 
class AddColumnToUserVisitorEmailSettings < ActiveRecord::Migration
  def self.up
    add_column :user_visitor_email_settings, :is_approved, :boolean , :default=>false
  end

  def self.down
    remove_column :user_visitor_email_settings, :is_approved
  end
end
