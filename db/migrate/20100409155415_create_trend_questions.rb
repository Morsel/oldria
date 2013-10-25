#encoding: utf-8 
class CreateTrendQuestions < ActiveRecord::Migration
  def self.up
    create_table :trend_questions do |t|
      t.string :subject
      t.text :body
      t.datetime :scheduled_at
      t.datetime :expired_at
      t.integer :criteria_id

      t.timestamps
    end
  end

  def self.down
    drop_table :trend_questions
  end
end
