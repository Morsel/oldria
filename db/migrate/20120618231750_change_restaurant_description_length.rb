class ChangeRestaurantDescriptionLength < ActiveRecord::Migration
  def self.up
    change_column :restaurants, :description, :text, :limit => nil
  end

  def self.down
    change_column :restaurants, :description, :string
  end
end