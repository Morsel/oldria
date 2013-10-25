#encoding: utf-8 
class MakeSoapboxSlidesGeneric < ActiveRecord::Migration
  def self.up
    rename_table :soapbox_slides, :slides
    add_column :slides, :type, :string
    change_column :slides, :image_updated_at, :datetime
    Slide.all(:conditions => { :type => nil }).each { |s| s.update_attribute(:type, "SoapboxSlide") }
  end

  def self.down
    rename_table :slides, :soapbox_slides
    remove_column :slides, :type
    change_column :slides, :image_updated_at, :integer
  end
end
