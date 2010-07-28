class CreateProfileQuestions < ActiveRecord::Migration
  def self.up
    create_table :profile_questions do |t|
      t.integer :topic_id
      t.integer :chapter_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :profile_questions
  end
end
