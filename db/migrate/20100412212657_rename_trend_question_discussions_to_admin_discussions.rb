#encoding: utf-8 
class RenameTrendQuestionDiscussionsToAdminDiscussions < ActiveRecord::Migration
  def self.up
    rename_table :trend_question_discussions, :admin_discussions
  end

  def self.down
    rename_table :admin_discussions, :trend_question_discussions
  end
end