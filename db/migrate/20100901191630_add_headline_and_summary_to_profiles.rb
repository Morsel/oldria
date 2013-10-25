#encoding: utf-8 
class AddHeadlineAndSummaryToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :headline, :string, :default => ""
    add_column :profiles, :summary, :text, :default => ""
  end

  def self.down
    remove_column :profiles, :summary
    remove_column :profiles, :headline
  end
end
