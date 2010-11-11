class MakePromosGeneric < ActiveRecord::Migration
  def self.up
    rename_table :soapbox_promos, :promos
    add_column :promos, :type, :string
  end

  def self.down
    remove_column :promos, :type
    rename_table :promos, :soapbox_promos
  end
end
