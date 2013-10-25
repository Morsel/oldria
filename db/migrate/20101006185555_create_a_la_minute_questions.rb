#encoding: utf-8 
class CreateALaMinuteQuestions < ActiveRecord::Migration
  def self.up
    create_table :a_la_minute_questions do |t|
      t.text :question
      t.string :kind

      t.timestamps
    end
  end

  def self.down
    drop_table :a_la_minute_questions
  end
end
