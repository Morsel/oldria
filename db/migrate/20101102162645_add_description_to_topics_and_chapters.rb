#encoding: utf-8 
class AddDescriptionToTopicsAndChapters < ActiveRecord::Migration
  def self.up
    add_column :topics, :description, :string
    add_column :chapters, :description, :string
  end

  def self.down
    remove_column :chapters, :description
    remove_column :topics, :description
  end
end
