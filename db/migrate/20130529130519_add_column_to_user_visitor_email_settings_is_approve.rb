#encoding: utf-8 
class AddColumnToUserVisitorEmailSettingsIsApprove < ActiveRecord::Migration
  def self.up
  	remove_column :user_visitor_email_settings, :is_approved
    add_column :user_visitor_email_settings, :is_approved, :boolean , :default=>true
  end

  def self.down
    remove_column :user_visitor_email_settings, :is_approved
    add_column :user_visitor_email_settings, :is_approved, :boolean
  end
end
