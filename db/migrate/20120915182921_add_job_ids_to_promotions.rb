#encoding: utf-8 
class AddJobIdsToPromotions < ActiveRecord::Migration
  def self.up
    add_column :promotions, :twitter_job_id, :integer
    add_column :promotions, :facebook_job_id, :integer
  end

  def self.down
    remove_column :promotions, :twitter_job_id
    remove_column :promotions, :facebook_job_id
  end
end
