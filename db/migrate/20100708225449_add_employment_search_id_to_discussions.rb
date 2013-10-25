#encoding: utf-8 
class AddEmploymentSearchIdToDiscussions < ActiveRecord::Migration
  def self.up
    add_column :discussions, :employment_search_id, :integer
  end

  def self.down
    remove_column :discussions, :employment_search_id
  end
end
