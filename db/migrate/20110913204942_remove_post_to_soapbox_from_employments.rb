#encoding: utf-8 
class RemovePostToSoapboxFromEmployments < ActiveRecord::Migration
  def self.up
    remove_column :employments, :post_to_soapbox
  end

  def self.down
    add_column :employments, :post_to_soapbox, :boolean, :default => true
  end
end
