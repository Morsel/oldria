#encoding: utf-8 
class CreateChapterQuestionMemberships < ActiveRecord::Migration
  def self.up
    create_table :chapter_question_memberships do |t|
      t.integer :chapter_id
      t.integer :profile_question_id
      t.integer :position

      t.timestamps
    end
    Chapter.all do |c|
      c.profile_questions do |p| 
        ChapterQuestionMembership.create(:chapter_id => c.id, :profile_question_id => p.id, :position => p.position)
      end
    end
    drop_table :chapters_profile_questions
    remove_column :profile_questions, :position
  end

  def self.down
    add_column :profile_questions, :position, :integer
    create_table :chapters_profile_questions, :id => false do |t|
      t.column :chapter_id, :integer
      t.column :profile_question_id, :integer
    end
    
    ChapterQuestionMembership.all do |m|
      Chapter.find(m.chapter_id).profile_questions << m.profile_question_id
    end

    drop_table :chapter_question_memberships
  end
end
