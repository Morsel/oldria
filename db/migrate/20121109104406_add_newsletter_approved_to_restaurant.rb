#encoding: utf-8 
class AddNewsletterApprovedToRestaurant < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :newsletter_approved, :boolean, :default => false
  end

  def self.down
    remove_column :restaurants, :newsletter_approved
  end
end
