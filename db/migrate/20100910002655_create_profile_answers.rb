#encoding: utf-8 
class CreateProfileAnswers < ActiveRecord::Migration
  def self.up
    create_table :profile_answers do |t|
      t.integer :profile_question_id
      t.text :answer

      t.timestamps
    end
  end

  def self.down
    drop_table :profile_answers
  end
end
