#encoding: utf-8 
class CreateChaptersProfileQuestions < ActiveRecord::Migration
  def self.up
    create_table :chapters_profile_questions, :id => false do |t|
      t.column :chapter_id, :integer
      t.column :profile_question_id, :integer
    end
    ProfileQuestion.all.each do |q|
      q.chapters << Chapter.find(q.chapter_id)
      q.save
    end
    remove_column :profile_questions, :chapter_id
  end

  def self.down
    add_column :profile_questions, :chapter_id, :integer
    ProfileQuestion.all.each do |q|
      q.chapter_id = q.chapters.first.id
      q.save
    end
    drop_table :chapters_profile_questions
  end
end
