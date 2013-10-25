#encoding: utf-8 
class CreateSoapboxSlides < ActiveRecord::Migration
  def self.up
    create_table :soapbox_slides do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.integer :image_updated_at
      t.string :title
      t.text :excerpt
      t.string :link
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :soapbox_slides
  end
end
