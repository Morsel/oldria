#encoding: utf-8 
class AddNewsletterFrequencyToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :newsletter_frequency, :string, :default => "biweekly"
  end

  def self.down
    remove_column :restaurants, :newsletter_frequency
  end
end
