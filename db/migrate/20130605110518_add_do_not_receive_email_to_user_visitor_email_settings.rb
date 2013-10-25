#encoding: utf-8 
class AddDoNotReceiveEmailToUserVisitorEmailSettings < ActiveRecord::Migration
  def self.up
  	remove_column :user_visitor_email_settings, :is_approved
  	remove_column :user_visitor_email_settings, :email_frequency_day
  	add_column :user_visitor_email_settings, :do_not_receive_email, :boolean , :default=>false
  end

  def self.down
  	add_column :user_visitor_email_settings, :is_approved
  	add_column :user_visitor_email_settings, :email_frequency_day
  	remove_column :user_visitor_email_settings, :do_not_receive_email, :boolean , :default=>false
  end
end
