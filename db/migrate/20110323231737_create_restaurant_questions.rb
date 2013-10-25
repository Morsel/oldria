#encoding: utf-8 
class CreateRestaurantQuestions < ActiveRecord::Migration
  def self.up
    create_table :restaurant_questions do |t|
      t.string :title
      t.integer :position
      t.integer :chapter_id
      t.text :pages_description

      t.timestamps
    end
  end

  def self.down
    drop_table :restaurant_questions
  end
end
