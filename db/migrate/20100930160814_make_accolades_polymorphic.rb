#encoding: utf-8 
class MakeAccoladesPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :accolades, :profile_id, :accoladable_id
    add_column :accolades, :accoladable_type, :string
  end

  def self.down
    remove_column :accolades, :accoladable_type
    rename_column :accolades, :accoladable_id, :profile_id
  end
end
