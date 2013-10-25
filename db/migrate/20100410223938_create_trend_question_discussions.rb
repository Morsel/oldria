#encoding: utf-8 
class CreateTrendQuestionDiscussions < ActiveRecord::Migration
  def self.up
    create_table :trend_question_discussions do |t|
      t.integer :restaurant_id
      t.integer :trend_question_id

      t.timestamps
    end
  end

  def self.down
    drop_table :trend_question_discussions
  end
end
