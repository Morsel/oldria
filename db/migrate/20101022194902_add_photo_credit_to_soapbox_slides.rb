#encoding: utf-8 
class AddPhotoCreditToSoapboxSlides < ActiveRecord::Migration
  def self.up
    add_column :soapbox_slides, :photo_credit, :string
  end

  def self.down
    remove_column :soapbox_slides, :photo_credit
  end
end
