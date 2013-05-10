class AddSkippColumnToProfile < ActiveRecord::Migration
  def self.up
  	add_column :profiles, :skipp_step, :integer
  end

  def self.down
  	remove_column :profiles, :skipp_step
  end
end
