#encoding: utf-8 
class AddPublishedStatusToSoapboxEntries < ActiveRecord::Migration
  def self.up
    add_column :soapbox_entries, :published, :boolean, :default => true
  end

  def self.down
    remove_column :soapbox_entries, :published
  end
end
