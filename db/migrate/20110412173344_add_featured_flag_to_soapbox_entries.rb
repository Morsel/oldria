#encoding: utf-8 
class AddFeaturedFlagToSoapboxEntries < ActiveRecord::Migration
  def self.up
    add_column :soapbox_entries, :daily_feature, :boolean, :default => false
  end

  def self.down
    remove_column :soapbox_entries, :daily_feature
  end
end
