#encoding: utf-8 
class AddNewsletterFrequencyDayToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :newsletter_frequency_day, :string, :default => "Thursday"
  end

  def self.down
    remove_column :restaurants, :newsletter_frequency_day
  end
end
