#encoding: utf-8 
class CreateALaMinuteAnswers < ActiveRecord::Migration
  def self.up
    create_table :a_la_minute_answers do |t|
      t.text :answer
      t.references :a_la_minute_question
      t.integer :responder_id
      t.string :responder_type

      t.timestamps
    end
  end

  def self.down
    drop_table :a_la_minute_answers
  end
end
