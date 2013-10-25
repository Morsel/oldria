#encoding: utf-8 
class AddDescriptionToSoapboxEntries < ActiveRecord::Migration
  def self.up
    add_column :soapbox_entries, :description, :text
  end

  def self.down
    remove_column :soapbox_entries, :description
  end
end
