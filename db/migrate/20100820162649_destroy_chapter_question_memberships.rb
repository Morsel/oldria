#encoding: utf-8 
class DestroyChapterQuestionMemberships < ActiveRecord::Migration
  def self.up
    add_column :profile_questions, :position, :integer, :default => 0
    add_column :profile_questions, :chapter_id, :integer
    
    # ProfileQuestion.all.each do |q|
    #   q.update_attributes(:chapter_id => Chapter.first.id, :position => 0)
    # end
    
    drop_table :chapter_question_memberships
  end

  def self.down
    create_table :chapter_question_memberships do |t|
      t.integer :chapter_id
      t.integer :profile_question_id
      t.integer :position

      t.timestamps
    end
    
    # ProfileQuestion.all.each do |p| 
    #   ChapterQuestionMembership.create(:chapter_id => p.chapter_id, :profile_question_id => p.id, :position => p.position)
    # end

    remove_column :profile_questions, :position
    remove_column :profile_questions, :chapter_id
  end
end
