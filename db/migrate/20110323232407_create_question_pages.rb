#encoding: utf-8 
class CreateQuestionPages < ActiveRecord::Migration
  def self.up
    create_table :question_pages do |t|
      t.integer :restaurant_question_id
      t.integer :restaurant_feature_page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :question_pages
  end
end
