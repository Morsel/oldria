class MakeSoapboxSlidesGeneric < ActiveRecord::Migration
  def self.up
    rename_table :soapbox_slides, :slides
    add_column :slides, :type, :string
    change_column :slides, :image_updated_at, :datetime
  end

  def self.down
    rename_table :slides, :soapbox_slides
    remove_column :slides, :type
    change_column :slides, :image_updated_at, :integer
  end
end
