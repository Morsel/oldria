#encoding: utf-8 
class CreateSoloDiscussions < ActiveRecord::Migration
  def self.up
    create_table :solo_discussions do |t|
      t.integer :employment_id
      t.integer :trend_question_id
      t.integer :comments_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :solo_discussions
  end
end
