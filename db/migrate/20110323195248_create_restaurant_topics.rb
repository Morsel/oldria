class CreateRestaurantTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :type, :string
    Topic.all(:conditions => { :responder_type => 'restaurant' }).each do |t|
      RestaurantTopic.create!(t.attributes)
      t.destroy
    end
    remove_column :topics, :responder_type
  end

  def self.down
    add_column :topics, :responder_type, :string
    RestaurantTopic.all.each do |t|
      Topic.create(t.attributes.merge(:responder_type => 'restaurant'))
      t.destroy
    end
    remove_column :topics, :type
  end
end
