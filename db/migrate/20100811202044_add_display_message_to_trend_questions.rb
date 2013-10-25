#encoding: utf-8 
class AddDisplayMessageToTrendQuestions < ActiveRecord::Migration
  def self.up
    add_column :trend_questions, :display_message, :string
  end

  def self.down
    remove_column :trend_questions, :display_message
  end
end
