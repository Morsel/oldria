class AddCommentsCountToTrendQuestionDiscussions < ActiveRecord::Migration
  def self.up
    add_column :trend_question_discussions, :comments_count, :integer
  end

  def self.down
    remove_column :trend_question_discussions, :comments_count
  end
end
