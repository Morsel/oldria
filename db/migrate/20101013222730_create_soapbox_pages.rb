#encoding: utf-8 
class CreateSoapboxPages < ActiveRecord::Migration
  def self.up
    create_table :soapbox_pages do |t|
      t.string :title
      t.string :slug
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :soapbox_pages
  end
end
