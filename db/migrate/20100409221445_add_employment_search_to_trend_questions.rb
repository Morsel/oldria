#encoding: utf-8 
class AddEmploymentSearchToTrendQuestions < ActiveRecord::Migration
  def self.up
    add_column :trend_questions, :employment_search_id, :integer
    remove_column :trend_questions, :criteria_id
  end

  def self.down
    add_column :trend_questions, :criteria_id, :integer
    remove_column :trend_questions, :employment_search_id
  end
end
