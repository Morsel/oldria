class CreateTraceKeywords < ActiveRecord::Migration
  def self.up
    create_table :trace_keywords do |t|
      t.integer :keywordable_id
      t.string :keywordable_type
      t.integer :user_id
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :trace_keywords
  end
end
