#encoding: utf-8 
class AddPageToTestimonials < ActiveRecord::Migration
  def self.up
    add_column :testimonials, :page, :string
  end

  def self.down
    remove_column :testimonials, :page
  end
end
