#encoding: utf-8 
class CreateRestaurantAnswers < ActiveRecord::Migration
  def self.up
    create_table :restaurant_answers do |t|
      t.integer :restaurant_question_id
      t.text :answer
      t.integer :restaurant_id

      t.timestamps
    end
  end

  def self.down
    drop_table :restaurant_answers
  end
end
