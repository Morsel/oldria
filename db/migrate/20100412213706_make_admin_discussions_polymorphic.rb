#encoding: utf-8 
class MakeAdminDiscussionsPolymorphic < ActiveRecord::Migration
  def self.up
    change_table :admin_discussions do |t|
      t.rename :trend_question_id, :discussionable_id
      t.string :discussionable_type
    end
    # All existing ones were Trend Questions, so migrate them.
    AdminDiscussion.update_all("discussionable_type = 'TrendQuestion'", 'discussionable_type IS NULL')
  end

  def self.down
    change_table :admin_discussions do |t|
      t.remove :discussionable_type
      t.rename :discussionable_id, :trend_question_id
    end
  end
end