#encoding: utf-8 
class AddPositionToProfileQuestions < ActiveRecord::Migration
  def self.up
    add_column :profile_questions, :position, :integer, :default => 0
  end

  def self.down
    remove_column :profile_questions, :position
  end
end
