#encoding: utf-8 
class AddTownsToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :hometown, :string
    add_column :profiles, :current_residence, :string
  end

  def self.down
    remove_column :profiles, :current_residence
    remove_column :profiles, :hometown
  end
end
