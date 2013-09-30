class AddSearchableByMediaToEmployment < ActiveRecord::Migration
  def self.up
    add_column :employments, :search_by_media, :boolean , :default => 0
  end

  def self.down
    remove_column :employments, :search_by_media
  end
end
