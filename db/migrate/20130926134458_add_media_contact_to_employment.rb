class AddMediaContactToEmployment < ActiveRecord::Migration
  def self.up
    add_column :employments, :media_contact, :boolean , :default => 0
  end

  def self.down
    remove_column :employments, :media_contact
  end
end
