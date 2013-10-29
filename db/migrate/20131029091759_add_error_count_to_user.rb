class AddErrorCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :error_count, :integer
  end

  def self.down
    remove_column :users, :error_count
  end
end
