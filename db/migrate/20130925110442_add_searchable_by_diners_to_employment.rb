class AddSearchableByDinersToEmployment < ActiveRecord::Migration
  def self.up
    add_column :employments, :search_by_diner, :boolean, :default => 0
  end

  def self.down
    remove_column :employments, :search_by_diner
  end
end
