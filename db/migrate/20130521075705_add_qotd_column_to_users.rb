class AddQotdColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :qotd, :boolean
  end

  def self.down
    remove_column :users, :qotd
  end
end
