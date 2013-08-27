class AddDayNameToDays < ActiveRecord::Migration
  def self.up
  	Date::DAYNAMES.each do |day_name|
  		Day.new(:name=>day_name).save
  	end
  end

  def self.down
  end
end
