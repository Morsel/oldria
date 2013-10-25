#encoding: utf-8 
class AddPositionToSoapboxPromos < ActiveRecord::Migration
  def self.up
    add_column :soapbox_promos, :position, :integer
  end

  def self.down
    remove_column :soapbox_promos, :position
  end
end
