#encoding: utf-8 
class AddTopicToALaMinuteQuestions < ActiveRecord::Migration
  def self.up
    add_column :a_la_minute_questions, :topic, :string
  end

  def self.down
    remove_column :a_la_minute_questions, :topic
  end
end
