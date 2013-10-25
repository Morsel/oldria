#encoding: utf-8 
class CreateRestaurantTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :type, :string
    Topic.all(:conditions => { :responder_type => 'restaurant' }).each do |t|
      t.update_attribute(:type, 'RestaurantTopic')
    end
    remove_column :topics, :responder_type
  end

  def self.down
    add_column :topics, :responder_type, :string
    RestaurantTopic.all.each do |t|
      t.update_attribute(:responder_type, 'restaurant')
    end
    remove_column :topics, :type
  end
end
