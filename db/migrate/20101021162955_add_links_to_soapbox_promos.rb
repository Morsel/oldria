#encoding: utf-8 
class AddLinksToSoapboxPromos < ActiveRecord::Migration
  def self.up
    add_column :soapbox_promos, :link, :string
  end

  def self.down
    remove_column :soapbox_promos, :link
  end
end
