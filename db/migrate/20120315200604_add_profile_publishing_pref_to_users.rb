#encoding: utf-8 
class AddProfilePublishingPrefToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :publish_profile, :boolean, :default => true
    User.all.each do |u|
      u.update_attribute(:publish_profile, false) if u.prefers_publish_profile == false
    end
  end

  def self.down
    remove_column :users, :publish_profile
  end
end
