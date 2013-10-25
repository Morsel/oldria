#encoding: utf-8 
class AddPublicToALaMinuteAnswers < ActiveRecord::Migration
  def self.up
    add_column :a_la_minute_answers, :show_as_public, :boolean
  end

  def self.down
    remove_column :a_la_minute_answers, :show_as_public
  end
end
