#encoding: utf-8 
class MakePromosGeneric < ActiveRecord::Migration
  def self.up
    rename_table :soapbox_promos, :promos
    add_column :promos, :type, :string
    Promo.all(:conditions => { :type => nil }).each { |s| s.update_attribute(:type, "SoapboxPromo") }
  end

  def self.down
    remove_column :promos, :type
    rename_table :promos, :soapbox_promos
  end
end
