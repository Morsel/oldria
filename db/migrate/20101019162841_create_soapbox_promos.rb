#encoding: utf-8 
class CreateSoapboxPromos < ActiveRecord::Migration
  def self.up
    create_table :soapbox_promos do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :soapbox_promos
  end
end
